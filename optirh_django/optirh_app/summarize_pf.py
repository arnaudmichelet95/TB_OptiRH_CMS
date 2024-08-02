import logging
import time
from django.core.files.uploadedfile import SimpleUploadedFile, UploadedFile
from .ollama.request_handler import llm_request_handler
from .models import Sum_request, Account
from django.db import transaction
import xml.etree.ElementTree as ET

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class SummarizePfHandler:
    def __init__(self, files: list[UploadedFile]):
        self.files = files
        self.request_manager = llm_request_handler()

    def extract_text_from_xml(self, file: UploadedFile):
        start_time = time.time()
        tree = ET.parse(file)
        root = tree.getroot()
        full_text = []

        for elem in root.iter():
            if elem.text:
                full_text.append(elem.text.strip())

        extracted_text = '\n\n'.join(full_text)
        extraction_time = time.time() - start_time
        logging.info(f"Time to extract text from {file.name}: {extraction_time:.2f} seconds")
        return extracted_text

    def summarize_pf_from_files(self, language):
        all_texts = []

        for file in self.files:
            text = self.extract_text_from_xml(file)
            all_texts.append(text)

        combined_text = '\n\n'.join(all_texts)

        prompt = (
            f"""You are a text summarization and medical expert. Given the following medical record, generate a medical summary in {language} in the following format (replace the values between "" by what you found in the medical record):

            Record:
            {combined_text}

            Format:
            Données personnelles:
            - Prénom: "Prénom"
            - Nom : "Nom"
            - Sexe: "Sexe"
            - N°AVS: "N°AVS"
            - Date de naissance: "Date de naissance"
            - Adresse: "Adresse"

            Cas:
            ""Complete sentence describing the case""

            Réseau social:
            - Référent: "Référent", tel: "Tel référent"
            - Médecin traitant: "Nom du médecin traitant", tel: "Tel médecin"

            Informations générales:
            "Complete sentence"

            Allergies:
            - "List of allergies"

            Historique médical:
            "Complete sentence describing the "Diagnostics""

            Médication:
            - Voie orale:
                - "List of medicaments"
            - Injection:
                - "Médicaments injection"
            """
        )

        start_time = time.time()
        response = self.request_manager.generate_response(prompt=prompt)
        response_str = ''.join(response)

        parsed_data = self.parse_response(response_str)
        generation_time = time.time() - start_time
        logging.info(f"Time to generate summary: {generation_time:.2f} seconds")

        return parsed_data

    def parse_response(self, response):
        """
        Parse the response to extract the various sections.
        """
        try:
            personal_data_start = response.find('Données personnelles:')
            case_start = response.find('Cas:')
            social_network_start = response.find('Réseau social:')
            general_info_start = response.find('Informations générales:')
            allergies_start = response.find('Allergies:')
            medic_history_start = response.find('Historique médical:')
            medication_start = response.find('Médication:')

            personal_data = response[personal_data_start + len('Données personnelles:'):case_start].strip()
            case = response[case_start + len('Cas:'):social_network_start].strip()
            social_network = response[social_network_start + len('Réseau social:'):general_info_start].strip()
            general_info = response[general_info_start + len('Informations générales:'):allergies_start].strip()
            allergies = response[allergies_start + len('Allergies:'):medic_history_start].strip()
            medic_history = response[medic_history_start + len('Historique médical:'):medication_start].strip()
            medication = response[medication_start + len('Médication:'):].strip()

        except IndexError:
            personal_data = ""
            case = ""
            social_network = ""
            general_info = ""
            allergies = ""
            medic_history = ""
            medication = ""

        # Remove any unwanted characters such as '*' from the beginning and end
        personal_data = personal_data.replace('*', '').strip()
        case = case.replace('*', '').strip()
        social_network = social_network.replace('*', '').strip()
        general_info = general_info.replace('*', '').strip()
        allergies = allergies.replace('*', '').strip()
        medic_history = medic_history.replace('*', '').strip()
        medication = medication.replace('*', '').strip()

        print (personal_data)

        return {
            "personal_data": personal_data,
            "case": case,
            "social_network": social_network,
            "general_info": general_info,
            "allergies": allergies,
            "medic_history": medic_history,
            "medication": medication
        }

    def insert_parsed_response_into_database(self, account_id, parsed_data, file_name):
        """
        Insert the parsed sections into the database using Django ORM.
        """
        try:
            with transaction.atomic():
                account = Account.objects.get(id=account_id)
                Sum_request.objects.create(
                    file_name=file_name,
                    personal_data=parsed_data["personal_data"],
                    case=parsed_data["case"],
                    social_network=parsed_data["social_network"],
                    general_info=parsed_data["general_info"],
                    allergy=parsed_data["allergies"],
                    medic_history=parsed_data["medic_history"],
                    medication=parsed_data["medication"],
                    fk_account=account
                )
                logging.debug(f"Inserted into DB: {parsed_data}")
        except Account.DoesNotExist:
            logging.error(f"Account with id {account_id} does not exist")
        except Exception as e:
            logging.error(f"An error occurred: {e}")


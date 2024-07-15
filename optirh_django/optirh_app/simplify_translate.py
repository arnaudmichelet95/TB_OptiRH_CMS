from .ollama.request_handler import llm_request_handler
from .models import Llm_request, Account
from django.db import transaction
import re

class SimplifyTranslateHandler:

    def __init__(self):
        self.request_manager = llm_request_handler()

    def simplify_translate_text(self, language, text, account_id):
        """
        Simplify and translate the input text into the specified language.
        """
        prompt = (
            f"You are a healthcare professional (nurse or care assistant) and you must answer in {language}. "
            "Vulgarize the text below in simple words that a 10-year-old child or an elderly person can understand. "
            "Start this section with 'Simplification: '. If the text contains medical terms, organs, or body parts, explain these words in simple words that everyone can understand. "
            "Start this section with 'Termes: '. Finally, give a summarized name in 5 words to this conversation, and start it with 'Summary: '. "
            "Do not include any other text or symbols like '*'. Here is the text: "
            + text
        )

        response = self.request_manager.generate_response(prompt=prompt)

        response_str = ''.join(response)
        vulgarization, term_explanation, request_name = self.parse_response(response_str)

        self.insert_parsed_response_into_database(account_id, vulgarization, term_explanation, request_name)
    
        return vulgarization, term_explanation
    
    def parse_response(self, response):
        """
        Parse the response to extract vulgarization, term explanations, and summary.
        """
        try:
            simplification_start = response.find('Simplification:')
            termes_start = response.find('Termes:')
            summary_start = response.find('Summary:')

            vulgarization = response[simplification_start + len('Simplification:'):termes_start].strip()
            term_explanation = response[termes_start + len('Termes:'):summary_start].strip()
            request_name = response[summary_start + len('Summary:'):].strip()

        except IndexError:
            vulgarization = response
            term_explanation = ''
            request_name = ''

        # Remove any unwanted characters such as '*' from the beginning and end
        vulgarization = vulgarization.replace('*', '').strip()
        term_explanation = term_explanation.replace('*', '').strip()
        request_name = request_name.replace('*', '').strip()

        return vulgarization, term_explanation, request_name
    
    
    def insert_parsed_response_into_database(self, account_id, vulgarization, term_explanation, request_name):
        """
        Insert the simplified text and term explanations into the database using Django ORM.
        """
        try:
            with transaction.atomic():
                account = Account.objects.get(id=account_id)
                Llm_request.objects.create(
                    vulgarization=vulgarization,
                    term_explanation=term_explanation,
                    trans_original='Original text here',  # Adjust as needed
                    trans_simplified='Simplified text here',  # Adjust as needed
                    fk_account=account,
                    request_name=request_name
                )
        except Account.DoesNotExist:
            print(f"Account with id {account_id} does not exist")
        except Exception as e:
            print(f"An error occurred: {e}")

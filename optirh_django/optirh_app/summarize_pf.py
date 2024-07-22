import logging
import time
from .ollama.request_handler import llm_request_handler
from django.core.files.uploadedfile import UploadedFile
from docx import Document

# Configurez le logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class SummarizePfHandler:
    def __init__(self, file: UploadedFile):
        self.file = file
        self.request_manager = llm_request_handler()  # Créer une instance de la classe

    def extract_text_from_docx(self):
        start_time = time.time()
        document = Document(self.file)
        full_text = []

        # Extraction des paragraphes
        for paragraph in document.paragraphs:
            full_text.append(paragraph.text)

        # Extraction des tableaux
        for table in document.tables:
            for row in table.rows:
                for cell in row.cells:
                    # Éviter la répétition de texte
                    if cell.text not in full_text:
                        full_text.append(cell.text)
        
        extraction_time = time.time() - start_time
        logging.info(f"Time to extract text: {extraction_time:.2f} seconds")

        return '\n'.join(full_text[:10000])  # Ajuster la limite selon vos besoins

    def summarize_pf_from_file(self, language):
        start_time = time.time()
        text = self.extract_text_from_docx()
        extraction_time = time.time() - start_time
        logging.info(f"Time to extract file: {extraction_time:.2f} seconds")

        prompt = (
            f"You are a text summarization expert. Summarize the following document content with sentences. "
            f"Only include the key points and important information and separate the information in paragraphs with titles. The response should be in {language}. "
            f"Here is the text: {text}" 
        )

        start_time = time.time()
        response = self.request_manager.generate_response(prompt=prompt)
        summary = ''.join(response)  # Convertir le générateur en chaîne de caractères
        generation_time = time.time() - start_time
        logging.info(f"Time to generate summary: {generation_time:.2f} seconds")

        return summary

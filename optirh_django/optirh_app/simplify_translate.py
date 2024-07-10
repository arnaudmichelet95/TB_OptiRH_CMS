from .ollama.request_handler import llm_request_handler

class SimplifyTranslateHandler:

    def __init__(self):
        self.request_manager = llm_request_handler()

    def simplify_translate_text(self, language, text):
        """
        Simplify and translate the input text into the specified language.
        """
        prompt = (
            "Vulgarize the text below with simple words so that a 10-year-old child can understand and translate it in "
            + language
            + ". If the text contains difficult medical terminology, organs or body parts, explain these with simple words that everybody can understand. Here is the text: "
            + text
        )

        response = self.request_manager.generate_response(prompt=prompt)

        return response
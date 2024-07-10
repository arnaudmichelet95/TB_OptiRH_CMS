import ollama

class llm_request_handler:
    """
    Handle requests to the Llama3 model hosted on an Ollama server.
    """
    
    def __init__(self, model_name='llama3'): 
        self.model_name = model_name

    def generate_response(self, prompt):
        """
        Generate a response from the Llama3 model based on the user's prompt.
        The response is returned as a stream of chunks.
        """
        stream = ollama.chat(
            model=self.model_name,
            messages=[{'role': 'user', 'content': prompt}],
            stream=True,
        )
        for chunk in stream:
            yield chunk['message']['content']

        
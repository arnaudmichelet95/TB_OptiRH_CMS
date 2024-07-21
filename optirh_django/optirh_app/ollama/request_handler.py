import subprocess
import json

class llm_request_handler:
    """
    Handle requests to the Llama3 model hosted on an Ollama server.
    """
    
    def __init__(self, model_name='llama3', adapter_name='llama3-8b-healthcare'):
        self.model_name = model_name
        self.adapter_name = adapter_name

    def generate_response(self, prompt):
        """
        Generate a response from the Llama3 model based on the user's prompt.
        The response is returned as a stream of chunks.
        """
        command = [
            "ollama", "run",
            self.model_name,
            "--adapter", self.adapter_name,
            "--prompt", prompt,
            "--max-tokens", "100",
            "--temperature", "0.7",
            "--top-p", "0.9"
        ]

        result = subprocess.run(command, capture_output=True, text=True, shell=True)

        if result.returncode == 0:
            response = result.stdout.strip()
            for chunk in self._stream_response(response):
                yield chunk
        else:
            raise Exception(f"Error {result.returncode}: {result.stderr.strip()}")

    def _stream_response(self, response):
        """
        Simulate streaming response by yielding chunks of the response.
        """
        chunk_size = 50
        for i in range(0, len(response), chunk_size):
            yield response[i:i + chunk_size]


# import torch
# from transformers import AutoModelForCausalLM, AutoTokenizer
# from peft import PeftModel, PeftConfig
# from decouple import config
# import logging
# import time

# # Configurer le logging
# logging.basicConfig(level=logging.DEBUG)
# logger = logging.getLogger(__name__)

# class llm_request_handler:
#     """
#     Handle requests to the Llama3 model using locally stored models.
#     """
    
#     def __init__(self, base_model_name=config('BASE_MODEL_PATH'), adapter_name=config('ADAPTER_PATH')):
#         # Log the base model and adapter paths
#         logger.debug(f"Base model path: {base_model_name}")
#         logger.debug(f"Adapter path: {adapter_name}")
        
#         # Charger le tokenizer et le modèle
#         self.tokenizer = AutoTokenizer.from_pretrained(base_model_name)
        
#         # Utiliser un GPU si disponible
#         self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
#         logger.debug(f"Using device: {self.device}")

#         base_model = AutoModelForCausalLM.from_pretrained(base_model_name, torch_dtype=torch.float16).to(self.device)
        
#         # Charger et vérifier la configuration de l'adaptateur
#         peft_config = PeftConfig.from_pretrained(adapter_name)
#         logger.debug(f"Loaded adapter configuration: {peft_config}")
        
#         # Vérifier le type de tâche
#         task_type = peft_config.task_type
#         logger.debug(f"Task type in config: {task_type}")
#         if task_type not in ["causal-lm", "seq2seq-lm", "token-classification"]:
#             logger.error(f"Invalid task type: {task_type}")
#             raise ValueError("Invalid task type in the adapter configuration")
        
#         # Charger le modèle avec l'adaptateur
#         self.model = PeftModel.from_pretrained(base_model, adapter_name).to(self.device)
#         logger.debug("Model loaded successfully with adapter.")

#     def generate_response(self, prompt):
#         """
#         Generate a response from the Llama3 model based on the user's prompt.
#         The response is returned as a stream of chunks.
#         """
#         logger.debug(f"Generating response for prompt: {prompt}")
        
#         # Chronométrer le traitement
#         start_time = time.time()
        
#         # Préparer les entrées avec une longueur maximale stricte
#         inputs = self.tokenizer(prompt, return_tensors='pt', max_length=256, truncation=True).to(self.device)
#         logger.debug(f"Tokenized inputs: {inputs}")
        
#         # Générer la réponse avec des paramètres limités
#         try:
#             outputs = self.model.generate(
#                 **inputs, 
#                 max_new_tokens=50,  # Réduire la longueur maximale des nouveaux tokens
#                 num_return_sequences=1,
#                 pad_token_id=self.tokenizer.eos_token_id,
#                 early_stopping=True,
#                 do_sample=True,  # Utiliser l'échantillonnage pour une réponse plus rapide
#                 top_k=50,        # Limiter à top-k tokens pour accélérer la génération
#                 temperature=0.7  # Réduire la température pour des réponses plus concises
#             )
#         except Exception as e:
#             logger.error(f"Error during generation: {e}")
#             return []
        
#         logger.debug(f"Generated outputs: {outputs}")
        
#         # Décoder la réponse
#         response = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
#         logger.debug(f"Decoded response: {response}")
        
#         # Temps écoulé
#         elapsed_time = time.time() - start_time
#         logger.debug(f"Time taken to generate response: {elapsed_time} seconds")
        
#         # Simulate streaming response
#         for chunk in self._stream_response(response):
#             yield chunk

#     def _stream_response(self, response):
#         """
#         Simulate streaming response by yielding chunks of the response.
#         """
#         chunk_size = 50  # Customize the chunk size as needed
#         for i in range(0, len(response), chunk_size):
#             yield response[i:i + chunk_size]
#             logger.debug(f"Streaming response chunk: {response[i:i + chunk_size]}")

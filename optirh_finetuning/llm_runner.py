from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, pipeline
import torch

class LLMRunner:
    def __init__(self, model_name: str, use_cuda: bool = True):
        """
        Initializes the LLMRunner with the specified model from Hugging Face.
        :param model_name: Name or path of the pre-trained or fine-tuned model on Hugging Face.
        :param use_cuda: Whether to use GPU if available.
        """
        self.device = torch.device('cuda' if use_cuda and torch.cuda.is_available() else 'cpu')
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForSeq2SeqLM.from_pretrained(model_name).to(self.device)

    def generate(self, input_text: str, max_length: int = 128, num_return_sequences: int = 1) -> list:
        """
        Generates text based on the input using the model.
        :param input_text: The input text for the model to process.
        :param max_length: Maximum length of the generated text.
        :param num_return_sequences: Number of generated sequences to return.
        :return: List of generated texts.
        """
        inputs = self.tokenizer(input_text, return_tensors='pt').to(self.device)
        outputs = self.model.generate(
            **inputs,
            max_length=max_length,
            num_return_sequences=num_return_sequences,
            num_beams=5,  # For beam search to improve generation quality
            early_stopping=True
        )
        return [self.tokenizer.decode(output, skip_special_tokens=True) for output in outputs]

# Function to compare models loaded from Hugging Face
def compare_models(base_model_name: str, fine_tuned_model_name: str, prompts: list):
    """
    Compares the outputs of a base model and a fine-tuned model on a set of prompts.
    :param base_model_name: Name or path of the base model on Hugging Face.
    :param fine_tuned_model_name: Name or path of the fine-tuned model on Hugging Face.
    :param prompts: List of prompts to run through both models.
    :return: Dictionary with the results for each prompt.
    """
    base_runner = LLMRunner(base_model_name)
    fine_tuned_runner = LLMRunner(fine_tuned_model_name)

    results = {}
    for prompt in prompts:
        base_output = base_runner.generate(prompt)
        fine_tuned_output = fine_tuned_runner.generate(prompt)
        results[prompt] = {
            "Base Model Output": base_output,
            "Fine-Tuned Model Output": fine_tuned_output
        }

    return results

prompts = [
    "Translate English to French: How are you?",
    "Summarize the following text: The quick brown fox jumps over the lazy dog."
]

results = compare_models('t5-small', 'your-username/your-fine-tuned-model', prompts)

for prompt, outputs in results.items():
    print(f"Prompt: {prompt}")
    print(f"Base Model Output: {outputs['Base Model Output']}")
    print(f"Fine-Tuned Model Output: {outputs['Fine-Tuned Model Output']}")
    print("------------------------------------------------------")

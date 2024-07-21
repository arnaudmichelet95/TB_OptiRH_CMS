import os
import argparse
from transformers import AutoModelForCausalLM, AutoTokenizer, logging
from peft import PeftModel
import torch
from huggingface_hub import HfApi, HfFolder

# Activer les logs détaillés
logging.set_verbosity_debug()

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--base_model_name_or_path", type=str, default="meta-llama/Meta-Llama-3-8B", help="Path to the base model or name on Hugging Face Hub")
    parser.add_argument("--peft_model_path", type=str, default="C:/PERSO/TB/Models/llama-8B_Healthcare", help="Path to the adapter model")
    parser.add_argument("--output_dir", type=str, default="C:/PERSO/TB/Models/llama3_adapter_merged", help="Path to save the combined model")
    parser.add_argument("--push_to_hub", action="store_true", default=False, help="Flag to push the model to Hugging Face Hub")
    parser.add_argument("--repo_name", type=str, default="amichelet95/llama3_8b_healthcare", help="Repository name on Hugging Face Hub")
    parser.add_argument("--huggingface_token", type=str, help="Hugging Face token")

    return parser.parse_args()

def main():
    args = get_args()

    # Vérifiez que le token Hugging Face est présent si on pousse vers le hub
    if args.push_to_hub and not args.huggingface_token:
        raise ValueError("Vous devez fournir un token Hugging Face pour pousser vers le hub.")

    try:
        if args.push_to_hub:
            print("Connexion à Hugging Face Hub pour vérifier le token...")
            api = HfApi()
            user = api.whoami(token=args.huggingface_token)
            print(f"Connecté en tant que {user['name']}")

        # Charger le modèle de base depuis Hugging Face Hub
        print(f"Chargement du modèle de base depuis Hugging Face Hub ({args.base_model_name_or_path})...")
        try:
            base_model = AutoModelForCausalLM.from_pretrained(
                args.base_model_name_or_path,
                return_dict=True,
                torch_dtype=torch.float16
            )
            print("Modèle de base chargé.")
        except Exception as e:
            print(f"Erreur lors du chargement du modèle de base : {e}")
            return

        # Charger l'adapter et fusionner
        print(f"Chargement de l'adapter depuis {args.peft_model_path}...")
        try:
            model = PeftModel.from_pretrained(base_model, args.peft_model_path)
            print("Adapter chargé. Fusion des modèles...")
            model = model.merge_and_unload()
            print("Modèles fusionnés.")
        except Exception as e:
            print(f"Erreur lors du chargement de l'adapter ou de la fusion : {e}")
            return

        # Charger le tokenizer
        print("Chargement du tokenizer...")
        try:
            tokenizer = AutoTokenizer.from_pretrained(args.base_model_name_or_path)
            print("Tokenizer chargé.")
        except Exception as e:
            print(f"Erreur lors du chargement du tokenizer : {e}")
            return

        # Sauvegarde ou push du modèle fusionné
        output_dir = args.output_dir
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        if args.push_to_hub:
            print(f"Sauvegarde du modèle fusionné dans {output_dir}...")
            model.save_pretrained(output_dir)
            tokenizer.save_pretrained(output_dir)
            print("Modèle sauvegardé localement. Poussée vers Hugging Face Hub...")
            try:
                HfFolder.save_token(args.huggingface_token)
                model.push_to_hub(args.repo_name, use_temp_dir=False, private=True)
                tokenizer.push_to_hub(args.repo_name, use_temp_dir=False, private=True)
                print("Modèle poussé vers Hugging Face Hub.")
            except Exception as e:
                print(f"Erreur lors de la poussée vers Hugging Face Hub : {e}")
        else:
            print(f"Sauvegarde du modèle fusionné dans {output_dir}...")
            try:
                model.save_pretrained(output_dir)
                tokenizer.save_pretrained(output_dir)
                print(f"Modèle fusionné sauvegardé dans {output_dir}.")
            except Exception as e:
                print(f"Erreur lors de la sauvegarde du modèle : {e}")
    
    except Exception as e:
        print(f"Une erreur est survenue : {e}")

if __name__ == "__main__":
    main()

from nltk.translate.bleu_score import sentence_bleu
import sacrebleu
from rouge_score import rouge_scorer
from nltk.translate.meteor_score import meteor_score
from sklearn.metrics import f1_score
from bert_score import score
from nltk.tokenize import word_tokenize


class LLMMetricTests:
    def __init__(self, texts):
        """
        Initializes the class with the different sets of reference and candidate texts for each metric.
        :param texts: Dictionary containing the reference and candidate texts for each metric.
                      Expected keys: 'bleu', 'rouge', 'meteor', 'f1', 'bert'
        """
        self.texts = texts

    def bleu_score(self):
        """
        Calculates the BLEU score using the specified reference and candidate texts.
        :return: BLEU Score
        """
        reference, candidate = self.texts['bleu']
        score = sentence_bleu([reference], candidate)
        return score

    def rouge_score(self):
        """
        Calculates the ROUGE score using the specified reference and candidate texts.
        :return: ROUGE-1 and ROUGE-L Scores
        """
        reference, candidate = self.texts['rouge']
        scorer = rouge_scorer.RougeScorer(['rouge1', 'rougeL'], use_stemmer=True)
        scores = scorer.score(candidate, reference)
        return scores

    def meteor_score(self):
        """
        Calculates the METEOR score using the specified reference and candidate texts.
        The texts are tokenized before calculation.
        :return: METEOR Score
        """
        reference, candidate = self.texts['meteor']
        reference_tokens = word_tokenize(reference)
        candidate_tokens = word_tokenize(candidate)
        score = meteor_score([reference_tokens], candidate_tokens)
        return score

    def f1_score(self):
        """
        Calculates the F1-Score using the specified true and predicted key points.
        :return: F1-Score
        """
        y_true, y_pred = self.texts['f1']
        score = f1_score(y_true, y_pred)
        return score

    def bert_score(self):
        """
        Calculates the BERTScore using the specified reference and candidate texts.
        :return: Average Precision, Recall, and F1-Score from BERTScore
        """
        reference, candidate = self.texts['bert']
        P, R, F1 = score([candidate], [reference], lang="en", verbose=True)
        return {'Precision': P.mean(), 'Recall': R.mean(), 'F1': F1.mean()}


# Example usage:

texts = {
    'bleu': ("This is a test", "This is test"),
    'rouge': ("This is a test", "This is test"),
    'meteor': ("This is a test", "This is test"),
    'f1': ([1, 1, 0, 0, 1], [1, 0, 0, 1, 1]),  # True labels and predicted labels
    'bert': ("This is a test", "This is test")
}

# Instantiate the class with the texts
metrics = LLMMetricTests(texts)

# Calculate and print the scores for each metric
print("BLEU Score:", metrics.bleu_score())
print("ROUGE Scores:", metrics.rouge_score())
print("METEOR Score:", metrics.meteor_score())
print("F1 Score:", metrics.f1_score())
print("BERTScore:", metrics.bert_score())

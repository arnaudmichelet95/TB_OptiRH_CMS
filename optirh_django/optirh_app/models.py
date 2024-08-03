from django.db import models
from django.contrib.auth.models import AbstractUser

class Account (AbstractUser):
    """
    Account class, used to store an account for the optirh application, inherits from AbstractUser to do the authentication part.
    """
    pass

class Llm_request(models.Model):
    request_name = models.TextField()
    original_text = models.TextField()
    vulgarization = models.TextField()
    term_explanation = models.TextField()
    fk_account = models.ForeignKey(Account, on_delete=models.CASCADE, related_name='fk_llm_requests_account_id')

    def __str__(self):
        return f"Llm_request {self.id} for Account {self.fk_account.username}"
    
class Sum_request(models.Model):
    file_name = models.TextField()
    personal_data = models.TextField()
    case = models.TextField()
    social_network = models.TextField()
    general_info = models.TextField()
    allergy = models.TextField()
    medic_history = models.TextField()
    medication = models.TextField()
    fk_account = models.ForeignKey(Account, on_delete=models.CASCADE, related_name='fk_summary_requests_account_id')

    def __str__(self):
        return f"Sum_request {self.id} for Account {self.fk_account.username}"

from django.db import models
from django.contrib.auth.models import AbstractUser

class Account (AbstractUser):
    """
    Account class, used to store an account for the optirh application, inherits from AbstractUser to do the authentication part.
    """
    pass

class Role (models.Model):
    name = models.CharField(max_length=50)

class Llm_request(models.Model):
    request_name = models.TextField()
    vulgarization = models.TextField()
    term_explanation = models.TextField()
    trans_original = models.TextField()
    trans_simplified = models.TextField()
    fk_account = models.ForeignKey(Account, on_delete=models.CASCADE, related_name='fk_llm_requests_account_id')

    def __str__(self):
        return f"Llm_request {self.id} for Account {self.fk_account.username}"

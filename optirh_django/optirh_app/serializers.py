from rest_framework import serializers
from.models import Account
from django.db.models import Q

class AccountSerializer(serializers.ModelSerializer):
    """
    AccountSerializer class, defines how the Account class must be serialized in json
    """
    class Meta:
        model = Account
        fields = ['id', 'email']
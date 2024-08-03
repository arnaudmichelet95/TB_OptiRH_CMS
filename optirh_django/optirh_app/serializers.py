from rest_framework import serializers
from.models import Account, Llm_request, Sum_request
from django.db.models import Q

class AccountSerializer(serializers.ModelSerializer):
    """
    AccountSerializer class, defines how the Account class must be serialized in json
    """
    class Meta:
        model = Account
        fields = ['id', 'email']


class LlmRequestSerializer(serializers.ModelSerializer):
    """
    LlmRequestSerializer class, defines how the Llm_request class must be serialized in JSON
    """
    account = serializers.StringRelatedField(source='fk_account')

    class Meta:
        model = Llm_request
        fields = [
            'request_name',
            'original_text',
            'vulgarization',
            'term_explanation',
            'account'
        ]

class SumRequestSerializer(serializers.ModelSerializer):
    """
    SumRequestSerializer class, defines how the Sum_request class must be serialized in JSON
    """
    account = serializers.StringRelatedField(source='fk_account')

    class Meta:
        model = Sum_request
        fields = [
            'file_name',
            'personal_data',
            'case',
            'social_network',
            'general_info',
            'allergy',
            'medic_history',
            'medication',
            'account'
        ]
# Generated by Django 5.0.6 on 2024-07-15 15:19

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('optirh_app', '0002_llm_request'),
    ]

    operations = [
        migrations.RenameField(
            model_name='llm_request',
            old_name='fk_account_id',
            new_name='fk_account',
        ),
    ]

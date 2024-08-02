# Generated by Django 5.0.6 on 2024-08-02 14:38

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('optirh_app', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Sum_request',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('file_name', models.TextField()),
                ('personal_data', models.TextField()),
                ('case', models.TextField()),
                ('social_network', models.TextField()),
                ('general_info', models.TextField()),
                ('allergy', models.TextField()),
                ('medic_history', models.TextField()),
                ('medication', models.TextField()),
                ('fk_account', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='fk_summary_requests_account_id', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]

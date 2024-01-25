# Generated by Django 5.0.1 on 2024-01-24 20:03

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('rentra', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.RemoveField(
            model_name='renting',
            name='description',
        ),
        migrations.AddField(
            model_name='renting',
            name='owner',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, related_name='owned_rentings', to=settings.AUTH_USER_MODEL),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='renting',
            name='terms',
            field=models.TextField(null=True),
        ),
        migrations.AlterField(
            model_name='renting',
            name='amount_total',
            field=models.DecimalField(decimal_places=1, max_digits=6),
        ),
        migrations.AlterField(
            model_name='renting',
            name='renter',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='rented_rentings', to=settings.AUTH_USER_MODEL),
        ),
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('description', models.TextField(null=True)),
                ('price_type', models.CharField(choices=[('hourly', 'Hourly'), ('daily', 'Daily')], max_length=255)),
                ('price', models.DecimalField(decimal_places=1, max_digits=6)),
                ('category_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='rentra.category')),
            ],
        ),
        migrations.AddField(
            model_name='renting',
            name='product_id',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='rentra.product'),
            preserve_default=False,
        ),
    ]

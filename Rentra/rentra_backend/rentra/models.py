from django.db import models
from django.contrib.auth.models import User

class Renting(models.Model):
    name = models.CharField(max_length=255)
    product_id = models.ForeignKey('Product', on_delete=models.SET_NULL, null=True)
    owner = models.ForeignKey('auth.User', on_delete=models.SET_NULL, related_name='owned_rentings', null=True)
    renter = models.ForeignKey('auth.User', on_delete=models.SET_NULL, related_name='rented_rentings', null=True)
    terms = models.TextField(null=True)
    date_from = models.DateField()
    date_to = models.DateField()
    amount_total = models.DecimalField(max_digits=6, decimal_places=1)

class Category(models.Model):
    name = models.CharField(max_length=255)
    class Meta:
        verbose_name_plural = "Categories"

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(null=True)
    category_id = models.ForeignKey('Category', on_delete=models.SET_NULL, null=True)
    price_type = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=6, decimal_places=1)
    image = models.ImageField(null=True, upload_to='images')
    user_id = models.ForeignKey(User, on_delete=models.CASCADE, default=None, null=True)


class PriceType(models.Model):
    name = models.CharField(max_length=255)
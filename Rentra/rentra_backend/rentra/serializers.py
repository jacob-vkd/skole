from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Product, Category, PriceType

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email')

class RegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password')

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user



class ProductSerializer(serializers.ModelSerializer):

    class ProductCategorySerializer(serializers.ModelSerializer):
        class Meta:
            model = Category
            fields = ['name']

    category_id = ProductCategorySerializer(many=False)

    class Meta:
        model = Product
        fields = ['name', 'description', 'category_id', 'price_type', 'price', 'user_id', 'image']

class PriceTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = PriceType
        fields = ['name']


class CategorySerializer(serializers.ModelSerializer):
    product_set = ProductSerializer(many=True)
    class Meta:
        model = Category
        fields = ['name', 'product_set']
from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Product, Category

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

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']     

class ProductSerializer(serializers.ModelSerializer):
    category_id = CategorySerializer()
    class Meta:
        model = Product
        fields = ['name', 'description', 'category_id', 'price_type', 'price', 'image']


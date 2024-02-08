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


class ProductSerializer(serializers.ModelSerializer):
    category_id = serializers.PrimaryKeyRelatedField(queryset=Category.objects.all())
    class Meta:
        model = Product
        fields = ['name', 'description', 'category_id', 'price_type', 'price', 'user_id', 'image']

    # def create(self, validated_data):
    #     # Read the image data from validated data
    #     image_data = validated_data.pop('image', None)
    #     # Call the superclass's create method
    #     instance = super().create(validated_data)
    #     # If image data is provided, save it as binary to the instance
    #     if image_data:
    #         instance.image = image_data
    #         instance.save()
    #     return instance



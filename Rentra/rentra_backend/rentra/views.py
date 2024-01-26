from django.db import IntegrityError
from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Category
from .serializers import ProductSerializer
from .serializers import UserSerializer, RegistrationSerializer
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.middleware.csrf import get_token
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def get_csrf_token(request):
    csrf_token = get_token(request)
    return JsonResponse({'csrf_token': csrf_token})

class RegistrationView(generics.CreateAPIView):
    serializer_class = RegistrationSerializer
    permission_classes = (AllowAny,)

class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user

class ProductCreateView(APIView):
    def post(self, request, format=None):
        print(request.data)
        serializer = ProductSerializer(data=request.data)
        print(serializer)
        print(serializer.is_valid())
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

def user_login(request):
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))
        username = data.get("username")
        password = data.get("password")
        create_account = data.get("createaccount")

        if create_account and username is not None and password is not None:
            try:
                # Check if the user already exists
                if User.objects.filter(username=username).exists():
                    return JsonResponse({'message': 'Username already exists'}, status=400)

                user = User.objects.create_user(username=username, password=password)
                return JsonResponse({'message': 'User created successfully', 'username': user.username}, status=200)
            except IntegrityError as e:
                return JsonResponse({'message': 'Error creating user. Username might already exist.'}, status=400)
        else:
            user = authenticate(request, username=username, password=password)
            if user is not None:
                login(request, user)
                return JsonResponse({'message': 'Login successful', 'username': user.username}, status=200)

    return JsonResponse({'message': 'Bad Request: Invalid login data'}, status=400)

def logout_user(request):
        logout(request)
        return JsonResponse({'message': 'Logout successful'})
    
def get_current_user(request):
    # Check if the user is authenticated
    if request.user.is_authenticated:
        # Access user information
        username = request.user.username
        email = request.user.email
        # You can use this information to customize the response
        response_data = {
            'username': username,
            'email': email,
            'message': 'User is authenticated',
        }
    else:
        # User is not authenticated
        response_data = {
            'message': 'User is not authenticated',
        }
    return JsonResponse(response_data)

def categories(request):
    if request.method == 'GET':
        categories = Category.objects.all()
        category_list = [{'id': category.id, 'name': category.name} for category in categories]
        return JsonResponse({'categories': category_list})
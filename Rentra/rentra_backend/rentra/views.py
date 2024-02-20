from rest_framework import generics, status
from rest_framework.parsers import MultiPartParser
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.authtoken.models import Token
from .models import Category, Product, PriceType
from .serializers import UserSerializer, ProductSerializer, PriceTypeSerializer
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth import logout
from django.middleware.csrf import get_token
from django.shortcuts import get_object_or_404

USER = False

def get_csrf_token(request):
    csrf_token = get_token(request)
    return csrf_token

class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user


@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
class ProductCreateView(APIView):
    parser_classes = [MultiPartParser]  # Use MultiPartParser to handle multipart/form-data requests
    
    def post(self, request, format=None):
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['GET'])
def product(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def product_user(request):
    print(request.META)
    # Filter products where user_id matches request.user_id
    products = Product.objects.filter(user_id=request.data['user_id'])
    products_renting = Product.objects.filter(rented_by_user_id=request.data['user_id'])
    products_rented = products.filter(rented_by_user_id__isnull=False)
    # Convert queryset to JSON
    products_data = list(products.values())  # Convert queryset to list of dictionaries
    return Response({'products': products_data, 'products_rented': products_rented, 'products_renting': products_renting})

@api_view(['GET'])
def pricetype(request):
    pricetype = PriceType.objects.all()
    serializer = PriceTypeSerializer(pricetype, many=True)
    return Response(serializer.data)
    
@api_view(['POST'])
def create_user(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        user = User.objects.get(username=request.data['username'])
        user.set_password(request.data['password'])
        user.save()
        token = Token.objects.create(user=user)
        return Response({'token': token.key, 'user': serializer.data})
    return Response({'message': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def user_login(request):
    try:
        user = get_object_or_404(User, username=request.data['username'])
    except Exception as e:
        return Response({"message": "Not Found",'token': ''}, status=status.HTTP_400_BAD_REQUEST)
    if user.check_password(request.data['password']) == False:
        return Response({"message": "Not Found",'token': ''}, status=status.HTTP_400_BAD_REQUEST)
    token, created = Token.objects.get_or_create(user=user)
    serializer = UserSerializer(instance=user)
    return Response({"message": "Welcome", 'token': token.key, 'user': serializer.data})

@api_view(['POST'])
def logout_user(request):
    logout(request)
    return Response({'message': 'Logout successful'})

@api_view(['GET', 'POST'])
def categories(request):
    if request.method == 'GET':
        categories = Category.objects.all()
        category_list = [{'id': category.id, 'name': category.name} for category in categories]
        return JsonResponse({'categories': category_list})
    if request.method == 'POST':
        category = Category.objects.get(name=request.data['name'])
        return Response({'category_id': category.id})

@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated]) 
def test_token(request):
    print('TEST TOKEN')
    return Response({'message': f"Token test successful"})
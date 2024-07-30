from django.http import HttpResponse
from django.contrib.auth import authenticate, logout, login
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response as DRFResponse
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import authentication_classes, permission_classes
from .simplify_translate import SimplifyTranslateHandler
from .summarize_pf import SummarizePfHandler
from .serializers import AccountSerializer
from .serializers import LlmRequestSerializer
from .models import Account
from .models import Llm_request
import logging
import time

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def home(request):
    return HttpResponse("Hello, Django!")

@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    """
    Login view, used to authenticate an account on the application
    """
    uname = request.data.get('username')
    pwd = request.data.get('password')

    start_time = time.time()
    user = authenticate(username=uname, password=pwd)
    auth_time = time.time() - start_time
    logger.debug(f"Authentication time: {auth_time:.2f} seconds")

    if user is not None:
        login_start_time = time.time()
        # Log in the user and create the token to allow them to access the different pages
        login(user=user, request=request)
        token, created = Token.objects.get_or_create(user=user)
        serializer = AccountSerializer(user)
        login_time = time.time() - login_start_time
        logger.debug(f"Login and token generation time: {login_time:.2f} seconds")

        return Response({'message': 'Authentication successful', 'user': serializer.data, 'token': token.key}, status=status.HTTP_200_OK)
    else:
        return Response({'message': 'Authentication failed'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
@permission_classes([AllowAny])
def register_view(request):
    """
    Sign up view, used to create a new account on the application
    """
    uname = request.data.get('username')
    pwd = request.data.get('password')

    try:
        start_time = time.time()
        user = Account.objects.create_user(username=uname, email=uname, password=pwd)
        login_time = time.time() - start_time
        logger.debug(f"User creation time: {login_time:.2f} seconds")

        token_start_time = time.time()
        login(user=user, request=request)
        token, created = Token.objects.get_or_create(user=user)
        serializer = AccountSerializer(user)
        token_time = time.time() - token_start_time
        logger.debug(f"Login and token generation time: {token_time:.2f} seconds")

        return Response({'message': 'User registration successful', 'user': serializer.data, 'token': token.key}, status=status.HTTP_201_CREATED)
    except Exception as e:
        return Response({'message': 'User registration failed', 'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """
    Logout view, used to log out a connected account
    """
    try:
        start_time = time.time()
        user_token = Token.objects.get(user=request.user)
        user_token.delete()
        logout(request=request)
        logout_time = time.time() - start_time
        logger.debug(f"Logout time: {logout_time:.2f} seconds")

        return Response({'message': 'Logout successful'}, status=status.HTTP_200_OK)
    except Token.DoesNotExist:
        return Response({'message': 'Token does not exist'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'message': f'Error: {e}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def simplifyTranslate_view(request):
    text = request.data.get('text')
    language = request.data.get('language')

    if not text or not language:
        return DRFResponse({'error': 'Text and language are required.'}, status=status.HTTP_400_BAD_REQUEST)

    handler = SimplifyTranslateHandler()
    account_id = request.user.id

    start_time = time.time()
    vulgarization, term_explanation = handler.simplify_translate_text(language=language, text=text, account_id=account_id)
    processing_time = time.time() - start_time
    logger.debug(f"Simplify and translate processing time: {processing_time:.2f} seconds")

    return DRFResponse({'vulgarization': vulgarization, 'term_explanation': term_explanation}, status=status.HTTP_200_OK, content_type="application/json; charset=utf-8")


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def summarize_view(request):
    try:
        if not request.FILES.getlist('files'):
            return DRFResponse({'error': 'File is required.'}, status=status.HTTP_400_BAD_REQUEST)
        
        language = request.data.get('language')
        if not language:
            return DRFResponse({'error': 'Language is required.'}, status=status.HTTP_400_BAD_REQUEST)

        uploaded_files = request.FILES.getlist('files')
        summarizer = SummarizePfHandler(uploaded_files)
        summary = summarizer.summarize_pf_from_files(language)

        return DRFResponse({'summary': summary}, status=status.HTTP_200_OK, content_type="application/json; charset=utf-8")
    
    except Exception as e:
        logging.error(f"Error processing summarize request: {str(e)}")
        return DRFResponse({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def request_history_view(request):
    user = request.user
    requests = Llm_request.objects.filter(fk_account=user).order_by('-id')
    serializer = LlmRequestSerializer(requests, many=True)

    return DRFResponse(serializer.data, status=status.HTTP_200_OK, content_type="application/json; charset=utf-8")
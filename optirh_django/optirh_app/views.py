from django.http import HttpResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response as DRFResponse
from rest_framework import status
from rest_framework.permissions import AllowAny
from .simplify_translate import SimplifyTranslateHandler

def home(request):
    return HttpResponse("Hello, Django!")

@api_view(['POST'])
@permission_classes([AllowAny])
def simplifyTranslate_view(request):
    text = request.data.get('text')
    language = request.data.get('language')

    if not text or not language:
        return DRFResponse({'error': 'Text and language are required.'}, status=status.HTTP_400_BAD_REQUEST)

    handler = SimplifyTranslateHandler()
    response = handler.simplify_translate_text(language=language, text=text)

    # Collect the response chunks into a single string
    full_response = ''.join(response)

    return DRFResponse({'response': full_response}, status=status.HTTP_200_OK, content_type="application/json; chartset=utf-8")

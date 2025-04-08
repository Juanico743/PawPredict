from django.conf import settings
from django.conf.urls.static import static
from django.urls import path
from . import views 

urlpatterns = [
    path('', views.index, name='index'),
    path('download/', views.download, name='download'),  
    path('download-apk/', views.downloadFile, name='download-apk'), 
    path('thank-you/', views.downloadThankYou, name='thank-you'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
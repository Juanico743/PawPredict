from django.shortcuts import render, redirect
from django.http import FileResponse
import os
from django.conf import settings
from .models import DownloadLog

# Create your views here.

def download(request):
    file_path = os.path.join(settings.MEDIA_ROOT, 'downloads/PawPredict-v1.0.0.apk')  

    if os.path.exists(file_path):
        file_size = round(os.path.getsize(file_path) / (1024 * 1024), 2)  
    else:
        file_size = "File not found"

    total_downloads = DownloadLog.objects.count() 
    return render(request, 'download/download.html', {
        'total_downloads': total_downloads,
        'file_size': file_size
    })

def index(request):
    return render(request, 'download/index.html')

def downloadFile(request):
    file_path = os.path.join(settings.MEDIA_ROOT, 'downloads/PawPredict-v1.0.0.apk')
    if os.path.exists(file_path):
        response = FileResponse(open(file_path, 'rb'), as_attachment=True, filename='PawPredict.apk')
        
        request.session['downloaded'] = True

        return response

    else:
        return render(request, 'download/error.html', {'error_message': 'File not found'})

def downloadThankYou(request):
    if request.session.get('downloaded', False):
        DownloadLog.objects.create()
        request.session['downloaded'] = False 
        return render(request, 'download/download-thank-you.html')
    else:
        return redirect('download')
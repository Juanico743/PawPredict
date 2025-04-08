from django.db import models

# Create your models here.
class DownloadLog(models.Model):
    downloaded_at = models.DateTimeField(auto_now_add=True)  

    def __str__(self):
        return f"Downloaded on {self.downloaded_at}"
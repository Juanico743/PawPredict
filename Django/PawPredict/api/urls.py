from django.urls import path
from .views import (
    CleanInsertData,
    CleanInsertDataset,
    RequestVeterinarianData,
    GetSymptoms, 
    GetQuestion,
    GetQuestionLineUp, 
    PredictDisease,
    GetSeverityAndDescription,
    GetVetNames
)

urlpatterns = [
    path('cleanInsertData/', CleanInsertData.as_view(), name='clean-Insert-Data'),
    path('cleanInsertDataset/', CleanInsertDataset.as_view(), name='clean-Insert-Dataset'),
    path('requestVeterinarianData/', RequestVeterinarianData.as_view(), name='request-Veterinarian-Data'),
    path('getsymptoms/', GetSymptoms.as_view(), name='get-symptoms'),
    path('getquestion/', GetQuestion.as_view(), name='get-question'),  
    path('getquestionlineup/', GetQuestionLineUp.as_view(), name='get-question-line-up'),  


    path('predictdisease/', PredictDisease.as_view(), name='predict-disease'), 
 
    path('predictdescription/', GetSeverityAndDescription.as_view(), name='predict-description'),  
    path('getvetnames/', GetVetNames.as_view(), name='get-vet-names'),
]
from rest_framework.views import APIView
from rest_framework.response import Response
from django.db import connection
from .models import (
    VetClinic,
    VetClinicInfo,
    VetClinicContacts,
    DogSymptoms,
    DogDisease,
    DogDiseaseFindings,
    DogDiseaseFirstAid,
    ConnectedS
)

from .config import (
    vet_names,
    clinic_info_data,
    clinic_contact_data,

    dog_symptoms,
    dog_symptoms_connection,
    dog_disease,
    dog_disease_findings,
    dog_disease_first_aid,
)

import pandas as pd
from sklearn.linear_model import LogisticRegression
from django.http import JsonResponse
import numpy as np
import json

# pip install djangorestframework
# pip install pandas scikit-learn django numpy

myerror = ""

try:
    model = LogisticRegression()
    data = pd.read_csv("PawPredictDataset.csv")  # Assumes a header row
    X = data.drop("Disease", axis=1)
    y = data["Disease"]
    X = X.fillna(0) # Fill NaN before checking

    if X.isnull().any().any():
        raise ValueError(f"NaN values still found in the feature set (X).")

    if y.isnull().any():
        raise ValueError("NaN values found in the target variable (y).")

    model.fit(X, y)
    #Get Feature names from trained model
    feature_names = X.columns 
    accuracy = model.score(X, y) * 100

except FileNotFoundError:
    model = None
    X = None
    myerror = "csv not found."
except ValueError as ve:
    model = None
    X = None
    myerror = f"Data issue: {ve}"
except Exception as e:
    model = None
    X = None
    myerror = f"error loading: {e}"


class PredictDisease(APIView):
    def post(self, request):
        if not model or X is None:
            return JsonResponse({"error": f"Model failed: {myerror}"}, status=500)

        try:
            body = json.loads(request.body.decode('utf-8'))
            symptom_values = body.get("symptoms", [])

            if len(symptom_values) != len(X.columns):
                return JsonResponse({"error": f"Incorrect number of symptom values. symptoms:{len(symptom_values)} != columns: {len(X.columns)}"}, status=400)


            input_df = pd.DataFrame([symptom_values], columns=feature_names)

            if input_df.isnull().any().any():
                return JsonResponse({"error": "NaN values found in input data."}, status=400)

            prediction = model.predict(input_df)[0]

            return JsonResponse({
                "prediction": prediction,
                "accuracy_percentage": round(accuracy, 2) if accuracy is not None else "N/A",
                "success": True
            })

        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON format."}, status=400)
        except Exception as e:
            return JsonResponse({"error": f"Error: {e}"}, status=500)




class CleanInsertData(APIView):
    def get(self, request):


        VetClinic.objects.all().delete()
        VetClinicInfo.objects.all().delete()
        VetClinicContacts.objects.all().delete()

        with connection.cursor() as cursor:
            cursor.execute("ALTER TABLE api_vetclinic AUTO_INCREMENT = 1;")
            cursor.execute("ALTER TABLE api_vetclinicinfo AUTO_INCREMENT = 1;")
            cursor.execute("ALTER TABLE api_vetcliniccontacts AUTO_INCREMENT = 1;")


        clinics = [VetClinic(name=name) for name in vet_names]
        VetClinic.objects.bulk_create(clinics)

        clinics_map = {clinic.name: clinic for clinic in VetClinic.objects.all()}

        clinic_info_objects = [
            VetClinicInfo(
                vetId=clinics_map[vet_names[vetId - 1]],
                latitude=latitude,
                longitude=longitude,
                address=address,
                availability=availability,
                regular_hours=regular_hours,
                emergency_hours=emergency_hours
            )
            for vetId, latitude, longitude, address, availability, regular_hours, emergency_hours in clinic_info_data
        ]

        VetClinicInfo.objects.bulk_create(clinic_info_objects)

        clinic_contacts_objects = [
            VetClinicContacts(
                vetId=clinics_map[vet_names[vetId - 1]], 
                facebook=facebook,
                gmail=gmail,
                contact_number=contact_number,
                website=website,
                viber=viber,
                instagram=instagram
            ) 
            for vetId, facebook, gmail, contact_number, website, viber, instagram  in clinic_contact_data
        ]
        VetClinicContacts.objects.bulk_create(clinic_contacts_objects)

        return Response({
            "success": True, 
            "message": "Vet clinics and their info inserted successfully!"
        })
    

class CleanInsertDataset(APIView):
    def get(self, request):

        DogSymptoms.objects.all().delete()
        ConnectedS.objects.all().delete()
        DogDisease.objects.all().delete()
        DogDiseaseFindings.objects.all().delete()
        DogDiseaseFirstAid.objects.all().delete()

        with connection.cursor() as cursor:
            cursor.execute("ALTER TABLE api_dogsymptoms AUTO_INCREMENT = 1;")
            cursor.execute("ALTER TABLE api_connecteds AUTO_INCREMENT = 1;")
            cursor.execute("ALTER TABLE api_dogdisease AUTO_INCREMENT = 1;")
            cursor.execute("ALTER TABLE api_dogdiseasefindings AUTO_INCREMENT = 1;")
            cursor.execute("ALTER TABLE api_dogdiseasefirstaid AUTO_INCREMENT = 1;")


        symptoms = [
            DogSymptoms(
                name=name,
                question=question,
                question_description=description,
                common=common
            )
            for name, question, description, common in dog_symptoms
        ]
        DogSymptoms.objects.bulk_create(symptoms)

        symptoms_map = {symptom.id: symptom for symptom in DogSymptoms.objects.all()}

        connected_entries = [
            ConnectedS(
                symptomsId=symptoms_map[symptom_id],
                connectedId=connected_ids
            )
            for symptom_id, connected_ids in dog_symptoms_connection
        ]
        ConnectedS.objects.bulk_create(connected_entries)

        diseases = [DogDisease(name=name) for name in dog_disease]
        DogDisease.objects.bulk_create(diseases)

        diseases_map = {disease.name: disease for disease in DogDisease.objects.all()}

        findings = [
            DogDiseaseFindings(
                name=name,  
                severity=severity,
                disease_description=description,
                specialization=specialization
            )
            for name, severity, description, specialization in dog_disease_findings
        ]
        DogDiseaseFindings.objects.bulk_create(findings)

        first_aid = [
            DogDiseaseFirstAid(
                name=name,  
                firstAid=first_aid_desc
            )
            for name, first_aid_desc in dog_disease_first_aid
        ]
        DogDiseaseFirstAid.objects.bulk_create(first_aid)

        return Response({"status": "success", "message": "Dog symptoms, diseases, findings, and first aid dataset inserted successfully!"})
    


class RequestVeterinarianData(APIView):
    def get(self, request):
        vet_clinics = VetClinic.objects.all()

        result = []
        for clinic in vet_clinics:
            clinic_data = {
                "id": clinic.id,
                "name": clinic.name,
                "info": [],
                "contacts": []
            }

            clinic_info = VetClinicInfo.objects.filter(vetId=clinic)
            clinic_data["info"] = [
                {
                    "latitude": info.latitude,
                    "longitude": info.longitude,
                    "address": info.address,
                    "availability": info.availability,
                    "regular_hours": info.regular_hours,
                    "emergency_hours": info.emergency_hours,
                }
                for info in clinic_info
            ]

            clinic_contacts = VetClinicContacts.objects.filter(vetId=clinic)
            clinic_data["contacts"] = [
                {
                    "facebook": contact.facebook,
                    "instagram": contact.instagram,
                    "gmail": contact.gmail,
                    "contact_number": contact.contact_number,
                    "website": contact.website,
                    "viber": contact.viber,
                }
                for contact in clinic_contacts
            ]

            result.append(clinic_data)

        return Response({
            "success": True, 
            "vet_clinics": result
        })

class GetQuestion(APIView):
    def post(self, request):
        symptomsId = request.data.get("nextQuestion")  
        
        if not symptomsId:
            return Response({"error": "symptomsId is required"}, status=400)
        
        try:
            symptom = DogSymptoms.objects.get(id=symptomsId)
            
            return Response({"success": True, "question": symptom.question, "question_description": symptom.question_description}, status=200)
        
        except DogSymptoms.DoesNotExist:
            return Response({"error": "Symptom not found"}, status=404)
        except Exception as e:
            return Response({"error": str(e)}, status=500)


class GetSymptoms(APIView):
    def get(self, request):
        symptoms = DogSymptoms.objects.values("name", "common")
        return Response({"success": True, "symptoms": list(symptoms)})
        

class GetQuestionLineUp(APIView):
    def post(self, request):
        symptoms_name = request.data.get("SymptomsName")

        if not symptoms_name:
            return Response({"error": "SymptomsName is required"}, status=400)

        try:
            symptom = DogSymptoms.objects.get(name=symptoms_name)
            
            connected_entry = ConnectedS.objects.get(symptomsId=symptom)
            
            connected_ids = eval(connected_entry.connectedId)  

        except DogSymptoms.DoesNotExist:
            return Response({"error": "Symptom not found"}, status=404)
        except ConnectedS.DoesNotExist:
            return Response({"error": "No connected symptoms found"}, status=404)
        except Exception as e:
            return Response({"error": str(e)}, status=500)

        return Response({"connectedIds": connected_ids, "sypmtomsId": symptom.id,"success": True})


class GetSeverityAndDescription(APIView):
    def post(self, request):
        disease_name = request.data.get("name")

        if not disease_name:
            return Response({"success": False, "message": "Disease name is required"}, status=400)

        try:
            disease = DogDiseaseFindings.objects.get(name=disease_name)
            firstaid = DogDiseaseFirstAid.objects.filter(name=disease_name).values_list('firstAid', flat=True)

            specialized = eval(disease.specialization)

            return Response({
                "success": True,
                "description": disease.disease_description,
                "severity": disease.severity,
                "firstaid": list(firstaid),
                "specialized": specialized
            })

        except DogDiseaseFindings.DoesNotExist:
            return Response({"success": False, "message": "Disease not found"}, status=404)


class GetVetNames(APIView):
    def get(self, request):
        name = list(VetClinic.objects.values_list("name", flat=True))  
        return Response({"success": True, "vetlist": name})
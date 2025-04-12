from django.db import models

# VETERINARY CLINIC
class VetClinic(models.Model):
    name = models.CharField(max_length=255) 

    def __str__(self):
        return self.name

# VETERINARY CLINIC INFORMATION
class VetClinicInfo(models.Model):
    vetId = models.ForeignKey(VetClinic, on_delete=models.CASCADE, related_name="info")  
    latitude = models.DecimalField(max_digits=18, decimal_places=15) 
    longitude = models.DecimalField(max_digits=18, decimal_places=15)  
    address = models.TextField()
    availability = models.CharField(max_length=255) 
    regular_hours = models.CharField(max_length=100)  
    emergency_hours = models.CharField(max_length=100) 

    def __str__(self):
        return f"{self.vetId.name} - {self.address}"
    

class VetClinicContacts(models.Model):
    vetId = models.ForeignKey(VetClinic, on_delete=models.CASCADE, related_name="contacts")  
    facebook = models.URLField(blank=True, null=True)  
    instagram = models.URLField(blank=True, null=True)  
    gmail = models.EmailField(blank=True, null=True)  
    contact_number = models.CharField(max_length=20, blank=True, null=True)  
    website = models.URLField(blank=True, null=True)  
    viber = models.CharField(max_length=20, blank=True, null=True)  

    def __str__(self):
        return f"Contacts for {self.clinic.name}"
    

class DogSymptoms(models.Model):
    name = models.CharField(max_length=255)
    question = models.TextField()
    question_description = models.TextField()
    common = models.BooleanField(default=False)

    def __str__(self):
        return self.name
    
class ConnectedS(models.Model):
    symptomsId = models.ForeignKey(DogSymptoms, on_delete=models.CASCADE, related_name="connection")
    connectedId = models.TextField()

    def __str__(self):
        return self.name


class DogDisease(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name


class DogDiseaseFindings(models.Model):
    name = models.CharField(max_length=255, default="Unknown Disease")
    severity = models.CharField(max_length=50)
    disease_description = models.TextField()
    specialization = models.TextField(default="[]")

    def __str__(self):
        return f"{self.name} - Severity: {self.severity}"


class DogDiseaseFirstAid(models.Model):
    name = models.CharField(max_length=255, default="Unknown Disease")
    firstAid = models.TextField()

    def __str__(self):
        return f"{self.name} - First Aid Info"  
    


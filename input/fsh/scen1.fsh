Alias: $fhir-types = http://hl7.org/fhir/fhir-types

Instance: example
InstanceOf: ExampleScenario
Usage: #definition
* status = #draft
* purpose = "This serves to demonstrate the performing of medication administration, by using remote / mobile devices to a) Get the planned medication administrations and b) Record the performing of these administrations without a permanent connection to the EHR."
* actor[0]
  * key = "Nurse"
  * type = #person
  * title = "Nurse"
  * description = "The Nurse"
* actor[+] 
  * key = "MAP"
  * type = #system
  * title = "Nurse's Tablet"
  * description = "The entity that receives the Administration Requests to show the nurse to perform them"
* actor[+]
  * key = "OP"
  * type = #system
  * title = "MAR / Scheduler"
  * description = "The Medication Administration Order Placer"
* actor[+]
  * key = "MAC"
  * type = #system
  * title = "MAR / EHR"
  * description = "The entity that receives the Medication Administration reports"
* instance[0]
  * key = "iherx001"
  * structureType = $fhir-types#MedicationRequest
  * title = "Initial Prescription"
  * description = "The initial prescription which describes \"medication X, 3 times per day\" - the exact scheduling is not   in the initial prescription (it is left for the care teams to decide on the schedule)."
* instance[+]
  * key = "iherx001.001"
  * structureType = $fhir-types#MedicationRequest
  * title = "Request for day 1, morning"
  * description = "The administration request for day 1, morning"
* instance[+]
  * key = "iherx001.002"
  * structureType = $fhir-types#MedicationRequest
  * title = "Request for day 1, lunch"
  * description = "The administration request for day 1, lunch"
* instance[+]
  * key = "iherx001.003"
  * structureType = $fhir-types#MedicationRequest
  * title = "Request for day 1, evening"
  * description = "The administration request for day 1, evening"
* instance[+]
  * key = "iherx001.004"
  * structureType = $fhir-types#MedicationRequest
  * title = "Request for day 2, morning"
  * description = "The administration request for day 2, morning"
* instance[+]
  * key = "iherx001.005"
  * structureType = $fhir-types#MedicationRequest
  * title = "Request for day 2, lunch"
  * description = "The administration request for day 2, lunch"
* instance[+]
  * key = "iherx001.006"
  * structureType = $fhir-types#MedicationRequest
  * title = "Request for day 2, evening"
  * description = "The administration request for day 2, evening"
* instance[+]
  * key = "iheadm001a"
  * structureType = $fhir-types#MedicationAdministration
  * title = "Morning meds - taken"
  * description = "Administration report for day 1, morning: Taken"
* instance[+]
  * key = "iheadm001b"
  * structureType = $fhir-types#MedicationAdministration
  * title = "Morning meds - not taken"
  * description = "Administration report for day 1, morning: NOT Taken"
* instance[+]
  * key = "iherx001bundle"
  * structureType = $fhir-types#MedicationRequest
  * title = "Bundle of Medication Requests"
  * description = "All the medication Requests for Day 1"
  * containedInstance[0].instanceReference = "iherx001.001"
  * containedInstance[+].instanceReference = "iherx001.002"
  * containedInstance[+].instanceReference = "iherx001.003"
  * containedInstance[+].instanceReference = "iherx001.004"
  * containedInstance[+].instanceReference = "iherx001.005"
  * containedInstance[+].instanceReference = "iherx001.006"
* instance[+]
  * key = "iheadm002"
  * structureType = $fhir-types#MedicationAdministration
  * title = "Lunch meds - taken"
  * description = "Administration report for day 1, lunch: Taken"
  * version[0].key = "iheadm002v1"
  * version[=].description = "Medication just taken"
  * version[+].key = "iheadm002v2"
  * version[=].description = "Medication rejected"
* instance[+]
  * key = "iherxqry"
  * structureType = $fhir-types#SearchParameter
  * title = "Search query1"
  * description = "The search administration request for day 1, morning"
* process
  * title = "Mobile Medication Administration"
  * description = "This scenario demonstrates the process of getting the relevant medication instructions for a patient visit and reporting the results of administration. The scenario is as follows: After the prescription is issued, the institution schedules each individual administration event in the Medication Administration Record (MAR). When preparing for a visit, the nurse queries the MAR for the scheduled administrations, obtaining a bundle of records. The nurse then performs the care activities and registers the results in the device. Upon synchronization of the device and the institution, the results of administration are uploaded to the EHR, thus updating the MAR."
  * preConditions = "Medication administration requests are in the EHR / MAR, scheduled for each individual intake."
  * postConditions = "Medication administration Reports are submitted, EHR is updated."
  * step[0]
    * number = "1"
    * operation
      * title = "Get today's schedule"
      * initiator = "Nurse"
      * receiver = "MAP"
  * step[+]
    * number = "2"
    * operation
      * title = "Query administration orders"
      * initiator = "MAP"
      * receiver = "OP"
      * description = "Query for medication administration orders,\\n- For today's shifts\\n- For today's patients"
      * request.instanceReference = "iherxqry"
      * response.instanceReference = "iherx001bundle"
    * pause = true
  * step[+]
    * number = "3"
    * operation
      * title = "Notify (alert)"
      * initiator = "MAP"
      * receiver = "Nurse"
  * step[+] 
    * number = "4"
    * operation
      * title = "Read orders"
      * initiator = "Nurse"
      * receiver = "MAP"
    * pause = true
  * step[+]
    * number = "5"
    * operation
      * title = "Ask if patient took meds"
      * initiator = "Nurse"
      * receiver = "Nurse"
  * step[+]
    * alternative[0]
      * title = "Patient took meds"
      * description = "Invoke if patient took medications"
      * step
        * number = "6a"
        * operation
          * title = "Register meds taken"
          * initiator = "Nurse"
          * receiver = "MAP"
          * initiatorActive = true
    * alternative[+]
      * title = "No drugs"
      * description = "No, patient did not take meds"
      * step
        * number = "6b"
        * operation
          * title = "Register meds NOT taken"
          * initiator = "Nurse"
          * receiver = "MAP"
          * initiatorActive = true
    * alternative[+]
      * title = "Not clear"
      * description = "Unknown whether patient took medications or not"
    * pause = true
  * step[+] 
    * number = "7"
    * operation.title = "Administer drug"
    * operation.initiator = "Nurse"
    * operation.receiver = "Nurse"
  * step[+]
    * number = "8"
    * operation.title = "Record administration"
    * operation.initiator = "Nurse"
    * operation.receiver = "MAP"
    * operation.initiatorActive = true
    * pause = true
  * step[+]
    * number = "9"
    * operation.title = "Upload administration reports"
    * operation.initiator = "Nurse"
    * operation.receiver = "MAP"
    * operation.initiatorActive = true
    * operation.request.instanceReference = "iheadm002"
    * operation.request.versionReference = "iheadm002v1"
    * pause = true
  * step[+]
    * number = "10"
    * operation.title = "Upload administration reports"
    * operation.initiator = "MAP"
    * operation.receiver = "MAC"
    * operation.description = "The nurse's system uploads the administration results to the server"
    * operation.request.instanceReference = "iheadm001a"
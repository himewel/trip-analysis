shell:=/bin/bash
PROJECT_NAME=jobsity-17022023

.PHONY: init
init:
	gsutil ls -p ${PROJECT_NAME} -b gs://tf-backend-17022023 \
		|| gsutil mb -p ${PROJECT_NAME} -l us-central1 gs://tf-backend-17022023
	cd functions &&	rm new_trip.zip && zip -r new_trip.zip new_trip

.PHONY: start
start:
	python3 startup.py
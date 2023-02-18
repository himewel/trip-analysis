shell:=/bin/bash
PROJECT_NAME=trip-analysis-18022023

.PHONY: init
init:
	gcloud services enable cloudfunctions.googleapis.com --project ${PROJECT_NAME}
	gcloud services enable pubsub.googleapis.com --project ${PROJECT_NAME}
	gcloud services enable logging.googleapis.com --project ${PROJECT_NAME}
	gcloud services enable cloudbuild.googleapis.com --project ${PROJECT_NAME}

	gsutil ls -p ${PROJECT_NAME} -b gs://${PROJECT_NAME}-backend \
		|| gsutil mb -p ${PROJECT_NAME} -l us-central1 gs://${PROJECT_NAME}-backend
	
	cd functions/new_trip \
		&& zip -r new_trip.zip *
	cd functions/average \
		&& zip -r average.zip *

.PHONY: push
push:
	python3 scripts/push_data.py

.PHONY: update
update:
	cd functions/new_trip \
		&& rm -f new_trip.zip \
		&& zip -r new_trip.zip * \
		&& gsutil cp ./new_trip.zip gs://a351adc80cf2cf7d-gcf-source/ \
		&& gcloud functions deploy new-trip --source gs://a351adc80cf2cf7d-gcf-source/new_trip.zip

	cd functions/average \
		&& rm -f average.zip \
		&& zip -r average.zip * \
		&& gsutil cp ./average.zip gs://a351adc80cf2cf7d-gcf-source/ \
		&& gcloud functions deploy average --source gs://a351adc80cf2cf7d-gcf-source/average.zip
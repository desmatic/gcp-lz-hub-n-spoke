gcloud config set project ${TF_VAR_pipeline_project_id}

# create service account
GCP_SVC_ACC=$(gcloud iam service-accounts create ${TF_VAR_pipeline_project_id} --display-name "terraform pipeline" --project ${TF_VAR_pipeline_project_id} --format json | jq -r .email)

# bind roles to service account for the organization
for ROLE in \
    roles/billing.user \
    roles/compute.networkAdmin \
    roles/compute.xpnAdmin \
    roles/resourcemanager.folderAdmin \
    roles/resourcemanager.organizationAdmin \
    roles/orgpolicy.policyAdmin \
    roles/resourcemanager.projectCreator \
    roles/resourcemanager.projectDeleter \
    roles/storage.admin
do
    echo "binding organization role $ROLE"
    gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
        --member="serviceAccount:${GCP_SVC_ACC}" \
        --role=${ROLE}
done

# TODO: bind roles to service account for a folder
LZ_FOLDER_ID=$(echo ${TF_VAR_landingzone_folder_id} | cut -d '/' -f2)
for ROLE in \
    roles/consumerprocurement.orderAdmin \
    roles/compute.networkAdmin \
    roles/compute.xpnAdmin \
    roles/resourcemanager.folderAdmin \
    roles/resourcemanager.organizationAdmin \
    roles/resourcemanager.projectCreator \
    roles/resourcemanager.projectDeleter \
    roles/storage.admin
do
    echo "binding organization role $ROLE"
    gcloud resource-manager folders add-iam-policy-binding ${LZ_FOLDER_ID} \
        --member="serviceAccount:${GCP_SVC_ACC}" \
        --role=${ROLE}
done

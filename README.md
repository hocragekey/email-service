# email-service
This repository contains the lambda and infra-as-code for my website email service.  
This is all orchestrated / deployed via travis ci and terraform.

To run the terraform plan navigate to the aws directory and run `terraform plan`

To run the lambda packaging script navigate to lambda/ses-lambda and run `gulp build`

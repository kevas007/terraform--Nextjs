#!/bin/bash
yum -y update
yum install httpd -y

systemctl start httpd
systemctl enable httpd
systemctl status httpd

sudo yum  install git -y
sudo amazon-linux-extras install epel

curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
yum -y install nodejs

git clone https://github.com/kevas007/beny-Project.git terraform-reactjs   &&  mv terraform-reactjs/* /var/www/html/

touch /var/www/html/.env

echo `
NEXT_PUBLIC_BASE_URL= ${hostname -I}
NEXT_PUBLIC_SANITY_DATASET=production
NEXT_PUBLIC_SANITY_PROJECT_ID=olvdn2ib
SANITY_API_TOKEN=skZp0BGlYqAOzRiCOHFQr9LLWdJjAldcZPt2IND95V9fhVZeSTXVnDhN4osoDpSIlzMe4pMJbawIyFIxjmsPtS4OnCSk9p6lJGff2MoiYYJBYcpR1lzA5iVErtJxeq0ZYpReYl2xJdTz2ViPOt6OiYc4A3yKuqAGz4AqfmffCVkiMPZ2jBUX    NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_51LuCI9KHamFsKNOt1zHWVBe6tTCHZLideq2eajB9VkR3HtiVG5AAOCUn8fqRZ6CWgZs1oEPVmHxnDQaXR6poacnD00NIhsXnv0
STRIPE_SECRET_KEY=sk_test_51LuCI9KHamFsKNOtTFG3yRvknZL4SLxqCQxucrTgEtqeWbdDDHQCOVVJsVM1hBOfVLCRlrNyz3WW3bGAQp8C7jb5001Az0UnTi


GOOGLE_ID_CLIENT_ID= 192073089772-djd4npuoupehmukedpnikfojnlhkam0j.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=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
NEXTAUTH_URL= ${hostname -I}
NEXTAUTH_SECRET=82f0a54b85f84b17eff3a503b95ae03a` >> /var/www/html/.env

npm --prefix /var/www/html/ install --force
npm  run --prefix /var/www/html/  build
mv /var/www/htmlt/appleredesign/dist/* /var/www/html/
systemctl restart httpd
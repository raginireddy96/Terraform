#application for v4
resource "aws_codedeploy_app" "v4-app" {
  compute_platform = "Server"
  name             = "v4-app"
}

# Deployment group for v4-app
resource "aws_codedeploy_deployment_group" "v4-api" {
    app_name = aws_codedeploy_app.v4-app.name
    deployment_group_name = "v4-api"
    deployment_style {
      deployment_type = "IN_PLACE"
    }
    auto_rollback_configuration {
      enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
    }
    service_role_arn = "arn:aws:iam::751115992403:role/CodeDeploy"
    autoscaling_groups = ["api-v4"]
    deployment_config_name = "CodeDeployDefault.OneAtATime"
    load_balancer_info {
      elb_info {
        name = "aws_lb.api-v4-elb.name"
      }
    }
  
}

# To get bucket details to store artifacts
data "aws_s3_bucket" "terraform-codedeploy" {
  bucket = "terraform-codedeploy"
}


#pipeline for v4
resource "aws_codepipeline" "api-v4" {
  name     = "api-v4"
  role_arn = "arn:aws:iam::751115992403:role/AWS-CodePipeline-Service"
  artifact_store {
    location = data.aws_s3_bucket.terraform-codedeploy.id
    type = "S3"
  }


  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "signeasy"
        Repo       = "v4"
        Branch     = "master-deployment-pp"
        OAuthToken = "1822e1e6cb2231f54762d2f353dbfb2cc67518ab"
      }
    }
  }

  

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName = "v4-app"
        DeploymentGroupName = "v4-api"
      } 
    }
  } 
}

#application for webapp
resource "aws_codedeploy_app" "webapp" {
  compute_platform = "Server"
  name             = "webapp"
}

# Deployment group for webapp
resource "aws_codedeploy_deployment_group" "webapp" {
    app_name = aws_codedeploy_app.webapp.name
    deployment_group_name = "webapp"
    deployment_style {
      deployment_type = "IN_PLACE"
    }
    auto_rollback_configuration {
      enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
    }
    service_role_arn = "arn:aws:iam::751115992403:role/CodeDeploy"
    deployment_config_name = "CodeDeployDefault.OneAtATime"
    ec2_tag_filter {
      key = "Name"
      type  = "KEY_AND_VALUE"
      value = "webapp-pp-signeasy-01"
    }
    ec2_tag_filter {
      key = "Name"
      type  = "KEY_AND_VALUE"
      value = "webapp-pp-signeasy-02"
    }
    load_balancer_info {
      target_group_info {
        name = aws_lb_target_group.webapp-tg.name
      }
    }
  
}

#pipeline for webapp-v2
resource "aws_codepipeline" "webapp" {
  name     = "webapp"
  role_arn = "arn:aws:iam::751115992403:role/AWS-CodePipeline-Service"
  artifact_store {
    location = data.aws_s3_bucket.terraform-codedeploy.id
    type = "S3"
  }


  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "signeasy"
        Repo       = "webapp-v2"
        Branch     = "deploymnt_script"
        OAuthToken = "1822e1e6cb2231f54762d2f353dbfb2cc67518ab"
      }
    }
  }

  

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ApplicationName = "webapp"
        DeploymentGroupName = "webapp"
      } 
    }
  } 
}

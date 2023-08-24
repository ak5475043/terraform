# resource "aws_autoscaling_policy" "sample_policy" {
#   name = "sample-policy"
#   scaling_adjustment = 1
#   adjustment_type = "ChangeInCapacity"
#   cooldown = 300 # Optional, adjust as needed
#   policy_type = "SimpleScaling"
  
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
    
#     target_value = 75 # Adjust this value as needed
#   }
# }
# soft-mandatory, hard-mandatory, advisory

policy "enforce-ec2-tags-size" {
  source = "./enforce-ec2-tags-size.sentinel"
  enforcement_level = "soft-mandatory"
}

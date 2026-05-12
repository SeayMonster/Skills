Write-Host "Adding Crisp Consulting Skills marketplace..."
claude plugins marketplace add github:michellesacia-lab/Skills

Write-Host "Installing crisp-bc-workflow-chart..."
claude plugins install crisp-bc-workflow-chart@michellesacia-lab

Write-Host "Installing crisp-bc-sdd..."
claude plugins install crisp-bc-sdd@michellesacia-lab

Write-Host "Done! Run 'claude plugins list' to verify."

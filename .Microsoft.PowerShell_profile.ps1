set-alias tf terraform

function ramkrishnahari {
    # 1. Execute the Azure login command and variable assignment
    $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)

    # 2. Add a dark-colored, personalized confirmation message
    # 'chalo apka pura kam karte hain' translates to 'come on, let's complete all your work'
    Write-Host "		RAM KRISHNA HARI DHANANAJAY, Good to see you here dear, "CHALO APKA KAM NIPTATE HAIN" 												" -ForegroundColor DarkGreen 

    # Optional: Display the set variable for confirmation
    # Write-Host "ARM_SUBSCRIPTION_ID set to: $($env:ARM_SUBSCRIPTION_ID)" -ForegroundColor DarkGreen
}

function infracost_login {
    # 1. Execute the Azure login command and variable assignment
    $env:INFRACOST_API_KEY="ico-hBFi3yZpqUV64EXzbn2aCk3YotFmvNR5"

    # 2. Add a dark-colored, personalized confirmation message
    # 'chalo apka pura kam karte hain' translates to 'come on, let's complete all your work'
    Write-Host "		infracost login ho gaya hain" 												" -ForegroundColor DarkGreen 

    # Optional: Display the set variable for confirmation
    # Write-Host "ARM_SUBSCRIPTION_ID set to: $($env:ARM_SUBSCRIPTION_ID)" -ForegroundColor DarkGreen
}

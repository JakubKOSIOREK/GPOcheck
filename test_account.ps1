Clear-Host

$c_set_file = ".\PC01-lgpo.xml" # workstation to check
$gpo_ref_file = ".\GPO_std_workstation_reference.xml" # references

$gpo_ref_data = [xml](Get-Content $gpo_ref_file)
$gpo_ref_ExtensionData = $gpo_ref_data.DocumentElement.ComputerResults.ExtensionData
$gpo_ref_Extension = $gpo_ref_ExtensionData.Extension
$gpo_ref_Account_list = $gpo_ref_Extension.Account
$local_data = [xml](Get-Content $c_set_file)
$local_ExtensionData = $local_data.DocumentElement.ComputerResults.ExtensionData
$local_Extension = $local_ExtensionData.Extension
$local_Account_list = $local_Extension.Account
$account_object = @()
foreach($gpo_ref_Account in $gpo_ref_Account_list){
    if($null -ne $gpo_ref_Account){
        $gpo_ref_Name = $gpo_ref_Account.Name
        $gpo_ref_SettingNumber = $gpo_ref_Account.SettingNumber
        $gpo_ref_SettingBoolean = $gpo_ref_Account.SettingBoolean

        if($null -ne $gpo_ref_SettingNumber){
            $gpo_ref_val = $gpo_ref_SettingNumber
        }else{
            if($null -ne $gpo_ref_SettingBoolean){
                $gpo_ref_val = $gpo_ref_SettingBoolean
            }else{$gpo_ref_val = "n/a"}
        }

        if($gpo_ref_Name -in $local_Account_list.Name){
            foreach($local_Account in $local_Account_list){
                $local_Name = $local_Account.Name
                $local_SettingNumber = $local_Account.SettingNumber
                $local_SettingBoolean = $local_Account.SettingBoolean
                if($local_Name -eq $gpo_ref_Name){
                    if($null -ne $local_SettingNumber){
                        $local_val = $local_SettingNumber
                    }else{
                        if($null -ne $local_SettingBoolean){
                            $local_val = $local_SettingBoolean
                        }else{$local_val = "n/a"}
                    }
                }
            }
        }else{$local_val = "n/a"}

        if($gpo_ref_val -ne $local_val){
            $account_object += [pscustomobject]@{
                Name=$gpo_ref_Name
                "GPO reference"=$gpo_ref_val
                "PC value"="$local_val"
            }
        }
    }
}
$account_object
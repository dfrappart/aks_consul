

locals {
    test = merge(var.ACRReplList,{sku=var.ACRSku})

    #test2 = {
    #    for_each = var.ACRReplList2
    #    {
    #        Location = var.ACRReplList2[each.value]
    #        ZoneRedundancyEnabled   = true
    #        Sku = var.ACRSku      
#
    #    }
    #}
}
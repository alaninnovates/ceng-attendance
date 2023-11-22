ca_ArrJoin(arr, sep) {
    result := ""
    for i, v in arr {
        result .= (i > 1 ? sep : "") . v
    }
    return result
}
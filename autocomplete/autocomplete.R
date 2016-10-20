load("words.rda")

autocomplete <- function(letters, data = words, word = NULL) {
        ## If given a phrase, find the last word
        r <- regexpr("[a-z0-9']+$", letters, perl = TRUE)
        letters <- regmatches(letters, r)
        regex <- paste0("^", letters)
        idx <- grep(regex, words, perl = TRUE)
        if(length(idx) > 0)
                data[idx[1]]
        else
                letters
}



### Unit tests for methodsEmapInternal.R functions

library(enrichViewNet)

data(demoGOST)


### Tests validateCreateEnrichMapArguments() results

context("validateCreateEnrichMapArguments() results")


test_that("validateCreateEnrichMapArguments() must return expected result", {
    
    result <- validateCreateEnrichMapArguments(gostObject=demoGOST, 
        query="query_1", source="GO:CC", termIDs=NULL, removeRoot=TRUE, 
        showCategory=30, groupCategory=FALSE, 
        categoryLabel=1, categoryNode=1)
    
    expect_true(result)
})

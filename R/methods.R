
#' @title Using functional enrichment results from gprofiler2 to create a 
#' Cytoscape network
#' 
#' @description User selected enrichment terms are used to create a Cytoscape 
#' network where the selected terms and the genes that where part of the 
#' enrichment analysis are all represented as nodes. Edges are linking the 
#' genes to their terms. The selection of the term can by specifying  the 
#' source of the terms (GO:MF, REAC, TF, etc...) or by listing the selected 
#' term IDs. The network is only generated when there is at least on 
#' significant term to graph.
#' 
#' @param gostObject a \code{list} created by gprofiler2 that contains
#' the results from an enrichment analysis.
#' 
#' @param source a \code{character} string representing the selected source 
#' that will be used to generate the network. To hand-pick the terms to be 
#' used, "TERM_ID" should be used and the list of selected term IDs should
#' be passed through the \code{termIDs} parameter. The possible sources are 
#' "GO:BP" for Gene Ontology Biological Process, "GO:CC" for Gene Ontology  
#' Cellular Component, "GO:MF" for Gene Ontology Molecular Function, 
#' "KEGG" for Kegg, "REAC" for Reactome, "TF" for TRANSFAC, "MIRNA" for 
#' miRTarBase, "CORUM" for CORUM database, "HP" for Human phenotype ontology
#' and "WP" for WikiPathways.  Default: "TERM_ID".
#' 
#' @param removeRoot a \code{logical} that specified if the root terms of 
#' the selected source should be removed (when present). Default: \code{TRUE}.
#' 
#' @param termIDs a \code{vector} of \code{character} strings that contains the
#' term IDS retained for the creation of the network. Default: \code{NULL}.
#' 
#' @param title a \code{character} string representing the name assigned to 
#' the network. Default: "gprofiler network".
#' 
#' @param collection a \code{character} string representing the collection 
#' name assigned to the network. Default: "enrichment results".
#' 
#' @param fileName a \code{character} string representing the name of the
#' CX JSON file that is created when Cytoscape is not running. The name 
#' must have a '.cx' extension.
#' Default: "gprofilerNetwork_01.cx". 
#' 
#' @return \code{TRUE}
#' 
#' @examples
#'
#' ## Loading dataset containing result from an enrichment analysis done with
#' ## gprofiler2
#' data(demoGOST)
#'
#' ## Create network for Gene Ontology - Molecular Function related results
#' ## in Cytoscape (when the application is opened)
#' ## Otherwise, create a CX file in the temporary directory
#' ## The file can be opened in Cytoscape
#' createNetwork(gostObject=demoGOST, source="GO:MF", removeRoot=FALSE,
#'     title="GO Molecular Function Graph", 
#'     fileName=file.path(tempdir(), "GO_MF_demo.cx"))
#' 
#' 
#' @author Astrid Deschênes
#' @importFrom gprofiler2 gconvert
#' @importFrom RCy3 cytoscapePing 
#' @importFrom strex match_arg
#' @encoding UTF-8
#' @export
createNetwork <- function(gostObject, source=c("TERM_ID", "GO:MF", "GO:CC",
    "GO:BP", "KEGG", "REAC", "TF", "MIRNA", "HPA", "CORUM", "HP", "WP"), 
    termIDs=NULL, removeRoot=TRUE, title="gprofiler network", 
    collection="enrichment results", fileName="gprofilerNetwork.cx") {
    
    ## Validate source is among the possible choices
    source <- match_arg(source, ignore_case=TRUE)
    
    ## Validate parameters
    validateCreateNetworkArguments(gostObject=gostObject, source=source,
        termIDs = termIDs, removeRoot=removeRoot, fileName=fileName)
    
    ## Extract results
    gostResults <- gostObject$result
    
    ## Filter results
    if (source == "TERM_ID") {
        gostResults <- gostResults[gostResults$term_id %in% termIDs,]
    } else {
        gostResults <- gostResults[gostResults$source == source,]
    }
    
    ## Remove root term if required
    if (removeRoot) {
        gostResults <- removeRootTerm(gostResults)
        if (nrow(gostResults) == 0) {
            stop("With removal of the root term, there is no ", 
                    "enrichment term left")
        }
    }
    
    ## Test that Cytoscape is running
    isRunning <- isCytoscapeRunning()
    
    ## If cytoscape is running, publish network in Cytoscape
    ## Otherwise, create CX JSON file
    final <- FALSE
    if (isRunning) {
        final <- createCytoscapeNetwork(gostResults=gostResults, 
            gostObject=gostObject, title=title, collection=collection)
        message("Cystocape Network created.")
    } else {
        final <- createCytoscapeCXJSON(gostResults=gostResults, 
            gostObject=gostObject, title=title) 
        if (!file.exists(fileName)) {
            write(final, file=fileName, append=FALSE)
            message("CX JSON file \"", fileName, 
                            "\" has been created.\n")
        } else {
            id <- 0
            done <- FALSE
            while(!done || id > 99) {
                id <- id + 1
                newFileName <- paste0("gprofilerNetwork_", 
                                        sprintf("%02d", id), ".cx")
                if (!file.exists(newFileName)) {
                    write(final, file=newFileName, append=FALSE)
                    done <- TRUE
                }
                message("CX JSON file \"", newFileName, 
                                    "\" has been created.\n")
            }
        }
    }
    
    return(TRUE)
}
        
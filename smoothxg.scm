(define-module (smoothxg)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages version-control))

(define-public smoothxg
  (let ((version "0.4.0")
        (commit "a47dc50fa24bcd96c470377d9662b6df09fa2c6d")
        (package-revision "41"))
    (package
     (name "smoothxg")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/smoothxg.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0cjg0wqy9s3zvxapngnqpk13zpfdgk4d5d8gllcf8dbwq0jkak5n"))))
     (build-system cmake-build-system)
     (arguments
      `(#:tests? #f
        #:make-flags (list (string-append "CC=" ,(cc-for-target)))))
     (native-inputs
      `(("pybind11" ,pybind11)
        ("python" ,python)))
     (inputs
      `(("gcc" ,gcc-10)
        ("jemalloc" ,jemalloc)
        ("zlib" ,zlib)
        ("zstd" ,zstd "lib")))
     (synopsis "linearize and simplify variation graphs using blocked partial order alignment")
     (description
"Pangenome graphs built from raw sets of alignments may have complex
local structures generated by common patterns of genome
variation. These local nonlinearities can introduce difficulty in
downstream analyses, visualization, and interpretation of variation
graphs.

smoothxg finds blocks of paths that are collinear within a variation
graph. It applies partial order alignment to each block, yielding an
acyclic variation graph. Then, to yield a smoothed graph, it walks
the original paths to lace these subgraphs together. The resulting
graph only contains cyclic or inverting structures larger than the
chosen block size, and is otherwise manifold linear. In addition to
providing a linear structure to the graph, smoothxg can be used to
extract the consensus pangenome graph by applying the heaviest bundle
algorithm to each chain.

To find blocks, smoothxg applies a greedy algorithm that assumes that
the graph nodes are sorted according to their occurence in the graph's
embedded paths. The path-guided stochastic gradient descent based 1D
sort implemented in odgi sort -Y is designed to provide this kind of
sort.")
     (home-page "https://github.com/ekg/smoothxg")
     (license license:expat))))


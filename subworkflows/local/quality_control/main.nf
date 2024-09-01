include { FASTQC                 } from '../../../modules/nf-core/fastqc/main'
include { RENAME_FILES           } from '../../../modules/utils/rename_files.nf' addParams (params.RENAME_FILES)



workflow QUALITY_CONTROL {
    take:
        ch_samplesheet

    main:


        samples_tsv_file = ch_samplesheet
                    .map {it -> it[0].id+"\t"+it[0].library}
                    .collectFile(name: params.cohort_tsv, newLine: true, storeDir: "${params.outdir}/misc", cache: false)




        RENAME_FILES (ch_samplesheet)

        RENAME_FILES.out.files.dump(tag: 'RENAME_FILES.out.files')

        FASTQC (RENAME_FILES.out.meta_and_files)

    emit:
    samples_tsv_file
    reads_and_meta_ch      = RENAME_FILES.out.meta_and_files
    reads_ch               = RENAME_FILES.out.files
    multiqc_files          = FASTQC.out.zip.collect{it[1]}
    versions               = FASTQC.out.versions.first()


}

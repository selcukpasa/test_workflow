envs="/home/selcuk/workflow/test_workflow/extern/envs/samtools.yaml"

def get_bwa_map_input_fastqs(wildcards):
        return config["samples"][wildcards.sample]

rule bwa_map:
        input:
                "data/genome.fa",
                get_bwa_map_input_fastqs
        output:
                temp("mapped_reads/{sample}.bam")
        params:
                rg=r"@RG\tID:{sample}\tSM:{sample}"
        log:
                "logs/bwa_mem/{sample}.log"
        """threads sorgen dafuer wie viele Jobs geleichzeitig
        ausgefuehrt werden"""
        threads: 8
        shell:
                "(bwa mem -R '{params.rg}' -t {threads} {input} | "
                "samtools view -Sb -> {output}) 2> {log}"

rule samtools_sort:
        input:
                "mapped_reads/{sample}.bam"
        output:
                protected("sorted_reads/{sample}.bam")
        shell:
                "samtools sort -T sorted_reads/{wildcards.sample} "
                "-O bam {input} > {output}"

rule samtools_index:
        input:
                "sorted_reads/{sample}.bam"
        output:
                "sorted_reads/{sample}.bam.bai"
	conda:	envs
        shell:
                "samtools index {input}"

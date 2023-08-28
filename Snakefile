include: "rules/samtools.smk"

configfile: "config.yaml"

rule all:
	input:
		"plots/quals.svg"

rule bcftools_call:
	input:
		fa="data/genome.fa",
		bam=expand("sorted_reads/{sample}.bam", sample=config["samples"]),
		bai=expand("sorted_reads/{sample}.bam.bai", sample=config["samples"])
	output:
		"calls/all.vcf"
	params:
		rate=config["mutation_rate"]
	log:
		"logs/bcftools_call/all.log"
	shell:
		"(bcftools mpileup -f {input.fa} {input.bam} | "
		"bcftools call -P {params.rate} -mv -> {output}) 2> {log}"

rule plot_quals:
	input:
		"calls/all.vcf"
	output:
		"plots/quals.svg"
	script:
		"scripts/plot-quals.py"

#!/bin/bash
# CHECKPOINT_PATH=/dataset/fd5061f6/sat_pretrained/glm
# CHECKPOINT_PATH=/scratch/yerong/.cache/pyllama/glm-10b-1024
CHECKPOINT_PATH='gpt2'

source $1
MPSIZE=1
MAXSEQLEN=512
MASTER_PORT=$(shuf -n 1 -i 10000-65535)

#SAMPLING ARGS
TEMP=0.9
#If TOPK/TOPP are 0 it defaults to greedy sampling, top-k will also override top-p
TOPK=40
TOPP=0

script_path=$(realpath $0)
script_dir=$(dirname $script_path)

config_json="$script_dir/ds_config.json"

# python -m torch.distributed.launch --nproc_per_node=$MPSIZE --master_port $MASTER_PORT inference_eng_iprompt.py \
python inference_eng_iprompt.py \
       --mode inference \
       --model-parallel-size $MPSIZE \
       $MODEL_ARGS \
       --num-beams 4 \
       --no-repeat-ngram-size 5 \
       --length-penalty 0.7 \
       --fp16 \
       --out-seq-length $MAXSEQLEN \
       --temperature $TEMP \
       --top_k $TOPK \
       --output-path samples_glm \
       --batch-size 4 \
       --out-seq-length 500 \
       --mode inference \
       --input-source interactive \
       --sampling-strategy iPromptStrategy \
       --device $2

nvidia-smi
curl -fsSL https://ollama.com/install.sh | sh
# for evantual multiple L4's
export OLLAMA_SCHED_SPREAD=1
export ROCR_VISIBLE_DEVICES=0,1
export CUDA_VISIBLE_DEVICES=0,1
# L4 currently is running 24G vram for Ada - up from 16G for Ampere
ollama run gpt-oss:20b --verbose

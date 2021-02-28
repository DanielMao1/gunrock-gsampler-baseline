PARTITION_NAME="dgx2"
NODE_NAME="rl-dgx2-c24-u16"

#PARTITION_NAME="dgxa100_1tb"
#NODE_NAME="rl-dgx2-c24-u16"

NUM_GPUS=16

APP_NAME="geo"
BIN_PREFIX="../../build/bin/"
DATA_PREFIX="~/data/gunrock/hive_datasets/mario-2TB/geolocation/instagram/graph"
DATA1="instagram.mtx"
DATA2="instagram.labels"
APP_OPTIONS="--geo-iter=10"

OUTPUT_DIR="eval_mgpu/$PARTITION_NAME/$NODE_NAME"
mkdir -p $OUTPUT_DIR

for (( i=1; i<=$NUM_GPUS; i++))
do
    SLURM_CMD="srun -G $i -n $i -p $PARTITION_NAME -w $NODE_NAME"
    echo $SLURM_CMD $BIN_PREFIX$APP_NAME \
                market $DATA_PREFIX/$DATA1 \
                $DATA_PREFIX/$DATA2 \
                $APP_OPTIONS \
                "> ./$OUTPUT_DIR/${APP_NAME}_GPU$i.txt"
done


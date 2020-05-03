#pragma once
#include <cub/cub.cuh>

namespace gunrock {
namespace algo {
namespace sort {

enum order_t
{
  ASCENDING,
  DESCENDING
}

namespace radix
{
  namespace device {

  // XXX: Make DoubleBuffer optional, and add support from thrust/mgpu.
  // XXX: stream_t should be a context.

  // keys-only
  // Sorts keys into ascending order. (~2N auxiliary storage required)
  // DoubleBuffer: Sorts keys pairs into ascending order. (~N auxiliary storage
  // required)
  template<order_t order, typename key_t, typename storage_t, typename stream_t>
  error_t sort(const key_t* keys_in,
               key_t* keys_out,
               int num_items,
               storage_t* d_temp_storage = NULL,
               size_t& temp_storage_bytes = 0,
               int begin_bit = 0,
               int end_bit = sizeof(key_t) * 8,
               stream_t stream = 0,
               bool sync = false)
  {
    // Create a set of DoubleBuffers to wrap pairs of device pointers
    cub::DoubleBuffer<key_t> keys(keys_in, keys_out);

    if (order == order_t::ASCENDING) {
      // Determine temporary device storage requirements
      cub::DeviceRadixSort::SortKeys(
        d_temp_storage, temp_storage_bytes, keys, num_items);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceRadixSort::SortKeys(
        d_temp_storage, temp_storage_bytes, keys, num_items);
    }

    else // order_t::DESCENDING
    {
      // Determine temporary device storage requirements
      cub::DeviceRadixSort::SortKeysDescending(
        d_temp_storage, temp_storage_bytes, keys, num_items);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceRadixSort::SortKeysDescending(
        d_temp_storage, temp_storage_bytes, keys, num_items);
    }

    if (keys.Current() != keys_out) {
      key_t* keys_ = keys.Current();
      // XXX: cuda_copy
    }

    // XXX: Clean-up storage?
  }

  // key-value pairs
  // Sorts key-value pairs into ascending order. (~2N auxiliary storage
  // required) DoubleBuffer: Sorts key-value pairs into ascending order. (~N
  // auxiliary storage required)
  template<order_t order,
           typename key_t,
           typename value_t,
           typename storage_t,
           typename stream_t>
  error_t sort_pairs(const key_t* keys_in,
                     key_t* keys_out,
                     const value_t* values_in,
                     value_t* values_out,
                     int num_items,
                     storage_t* d_temp_storage = NULL,
                     size_t& temp_storage_bytes = 0,
                     int begin_bit = 0,
                     int end_bit = sizeof(key_t) * 8,
                     stream_t stream = 0,
                     bool sync = false)
  {
    // Create a set of DoubleBuffers to wrap pairs of device pointers
    cub::DoubleBuffer<key_t> keys(keys_in, keys_out);
    cub::DoubleBuffer<value_t> values(values_in, values_out);

    if (order == order_t::ASCENDING) {
      // Determine temporary device storage requirements
      cub::DeviceRadixSort::SortPairs(
        d_temp_storage, temp_storage_bytes, keys, values, num_items);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceRadixSort::SortPairs(
        d_temp_storage, temp_storage_bytes, keys, values, num_items);
    }

    else // order_t::DESCENDING
    {
      // Determine temporary device storage requirements
      cub::DeviceRadixSort::SortPairsDescending(
        d_temp_storage, temp_storage_bytes, keys, values, num_items);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceRadixSort::SortPairsDescending(
        d_temp_storage, temp_storage_bytes, keys, values, num_items);
    }

    if (keys.Current() != keys_out) {
      key_t* keys_ = keys.Current();
      // XXX: cuda_copy
    }

    if (values.Current() != values_out) {
      value_t* values_ = values.Current();
      // XXX: cuda_copy
    }

    // XXX: Clean-up storage?
  }

  // Segmented keys-only
  // Sorts segmented sections into ascending order. (~2N auxiliary storage
  // required) DoubleBuffer: Sorts segmented sections into ascending order. (~N
  // auxiliary storage required)
  template<order_t order,
           typename key_t,
           typename offset_t,
           typename storage_t,
           typename stream_t>
  error_t sort_segments(const key_t* keys_in,
                        key_t* keys_out,
                        int num_items,
                        int num_segments,
                        offset_t* begin_offset,
                        offset_t* end_offsets = (begin_offset + 1),
                        storage_t* d_temp_storage = NULL,
                        size_t& temp_storage_bytes = 0,
                        int begin_bit = 0,
                        int end_bit = sizeof(key_t) * 8,
                        stream_t stream = 0,
                        bool sync = false)
  {
    // Create a set of DoubleBuffers to wrap pairs of device pointers
    cub::DoubleBuffer<key_t> keys(keys_in, keys_out);

    if (order == order_t::ASCENDING) {
      // Determine temporary device storage requirements
      cub::DeviceSegmentedRadixSort::SortKeys(d_temp_storage,
                                              temp_storage_bytes,
                                              num_items,
                                              num_segments,
                                              d_offsets,
                                              d_offsets + 1);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceSegmentedRadixSort::SortKeys(d_temp_storage,
                                              temp_storage_bytes,
                                              num_items,
                                              num_segments,
                                              d_offsets,
                                              d_offsets + 1);
    }

    else // order_t::DESCENDING
    {
      // Determine temporary device storage requirements
      cub::DeviceSegmentedRadixSort::SortKeysDescending(d_temp_storage,
                                                        temp_storage_bytes,
                                                        num_items,
                                                        num_segments,
                                                        d_offsets,
                                                        d_offsets + 1);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceSegmentedRadixSort::SortKeysDescending(d_temp_storage,
                                                        temp_storage_bytes,
                                                        num_items,
                                                        num_segments,
                                                        d_offsets,
                                                        d_offsets + 1);
    }

    if (keys.Current() != keys_out) {
      key_t* keys_ = keys.Current();
      // XXX: cuda_copy
    }

    // XXX: Clean-up storage?
  }

  // Segmented keys-values pairs
  // Sorts segmented sections into ascending order. (~2N auxiliary storage
  // required) DoubleBuffer: Sorts segmented sections into ascending order. (~N
  // auxiliary storage required)
  template<order_t order,
           typename key_t,
           typename value_t,
           typename offset_t,
           typename storage_t,
           typename stream_t>
  error_t sort_segments_pairs(const key_t* keys_in,
                              key_t* keys_out,
                              const value_t* values_in,
                              const value_t* values_out,
                              int num_items,
                              int num_segments,
                              offset_t* begin_offset,
                              offset_t* end_offsets = (begin_offset + 1),
                              storage_t* d_temp_storage = NULL,
                              size_t& temp_storage_bytes = 0,
                              int begin_bit = 0,
                              int end_bit = sizeof(key_t) * 8,
                              stream_t stream = 0,
                              bool sync = false)
  {
    // Create a set of DoubleBuffers to wrap pairs of device pointers
    cub::DoubleBuffer<key_t> keys(keys_in, keys_out);

    if (order == order_t::ASCENDING) {
      // Determine temporary device storage requirements
      cub::DeviceSegmentedRadixSort::SortKeys(d_temp_storage,
                                              temp_storage_bytes,
                                              num_items,
                                              num_segments,
                                              d_offsets,
                                              d_offsets + 1);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceSegmentedRadixSort::SortKeys(d_temp_storage,
                                              temp_storage_bytes,
                                              num_items,
                                              num_segments,
                                              d_offsets,
                                              d_offsets + 1);
    }

    else // order_t::DESCENDING
    {
      // Determine temporary device storage requirements
      cub::DeviceSegmentedRadixSort::SortKeysDescending(d_temp_storage,
                                                        temp_storage_bytes,
                                                        num_items,
                                                        num_segments,
                                                        d_offsets,
                                                        d_offsets + 1);

      // Allocate temporary storage
      cudaMalloc(&d_temp_storage, temp_storage_bytes);

      // Run sorting operation
      cub::DeviceSegmentedRadixSort::SortKeysDescending(d_temp_storage,
                                                        temp_storage_bytes,
                                                        num_items,
                                                        num_segments,
                                                        d_offsets,
                                                        d_offsets + 1);
    }

    if (keys.Current() != keys_out) {
      key_t* keys_ = keys.Current();
      // XXX: cuda_copy
    }

    if (values.Current() != values_out) {
      value_t* values_ = values.Current();
      // XXX: cuda_copy
    }

    // XXX: Clean-up storage?
  }

  } // namespace device
} // namespace: radix

} // namespace sort
} // namespace algo
} // namespace gunrock
/**
 * @file build.hxx
 * @author Muhammad Osama (mosama@ucdavis.edu)
 * @brief
 * @date 2020-10-07
 *
 * @copyright Copyright (c) 2020
 *
 */

#pragma once

#include <gunrock/graph/detail/build.hxx>

namespace gunrock {
namespace graph {
namespace build {

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::csr_t<space, vertex_t, edge_t, weight_t>& csr) {
  return detail::builder<space>(properties, csr);
}

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::coo_t<space, vertex_t, edge_t, weight_t>& coo) {
  return detail::builder<space>(properties, coo);
}

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::csc_t<space, vertex_t, edge_t, weight_t>& csc) {
  return detail::builder<space>(properties, csc);
}

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::csr_t<space, vertex_t, edge_t, weight_t>& csr,
           format::coo_t<space, vertex_t, edge_t, weight_t>& coo) {
  return detail::builder<space>(properties, csr, coo);
}

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::csr_t<space, vertex_t, edge_t, weight_t>& csr,
           format::csc_t<space, vertex_t, edge_t, weight_t>& csc) {
  return detail::builder<space>(properties, csr, csc);
}

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::coo_t<space, vertex_t, edge_t, weight_t>& coo,
           format::csc_t<space, vertex_t, edge_t, weight_t>& csc) {
  return detail::builder<space>(properties, coo, csc);
}

template <memory_space_t space,
          typename edge_t,
          typename vertex_t,
          typename weight_t>
auto build(graph::graph_properties_t properties,
           format::csr_t<space, vertex_t, edge_t, weight_t>& csr,
           format::coo_t<space, vertex_t, edge_t, weight_t>& coo,
           format::csc_t<space, vertex_t, edge_t, weight_t>& csc) {
  return detail::builder<space>(properties, csr, coo, csc);
}

}  // namespace build
}  // namespace graph
}  // namespace gunrock
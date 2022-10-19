// Copyright(C) 1999-2022 National Technology & Engineering Solutions
// of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
// NTESS, the U.S. Government retains certain rights in this software.
//
// See packages/seacas/LICENSE for details

#pragma once

#include <Iohb_Layout.h>
#include <Ioss_CodeTypes.h>
#include <Ioss_DBUsage.h>
#include <Ioss_DatabaseIO.h>
#include <Ioss_IOFactory.h>
#include <Ioss_State.h>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <string>

namespace Ioss {
  class GroupingEntity;
  class EntityBlock;
  class CommSet;
  class EdgeBlock;
  class EdgeSet;
  class ElementBlock;
  class ElementSet;
  class FaceBlock;
  class FaceSet;
  class Field;
  class NodeBlock;
  class NodeSet;
  class PropertyManager;
  class Region;
  class SideBlock;
  class SideSet;
  class StructuredBlock;
} // namespace Ioss

/** \brief A namespace for the heartbeat database format.
 */
namespace Iohb {
  class Layout;

  enum class Format { DEFAULT = 0, SPYHIS = 1, TEXT, TS_TEXT, CSV, TS_CSV };

  class IOFactory : public Ioss::IOFactory
  {
  public:
    static const IOFactory *factory();

  private:
    IOFactory();
    Ioss::DatabaseIO *make_IO(const std::string &filename, Ioss::DatabaseUsage db_usage,
                              Ioss_MPI_Comm                communicator,
                              const Ioss::PropertyManager &props) const override;
  };

  class DatabaseIO : public Ioss::DatabaseIO
  {
  public:
    DatabaseIO(Ioss::Region *region, const std::string &filename, Ioss::DatabaseUsage db_usage,
               Ioss_MPI_Comm communicator, const Ioss::PropertyManager &props);
    DatabaseIO(const DatabaseIO &from)            = delete;
    DatabaseIO &operator=(const DatabaseIO &from) = delete;

    ~DatabaseIO() override;

    const std::string get_format() const override { return "HeartBeat"; }

    // Check capabilities of input/output database...  Returns an
    // unsigned int with the supported Ioss::EntityTypes or'ed
    // together. If "return_value & Ioss::EntityType" is set, then the
    // database supports that type (e.g. return_value & Ioss::FACESET)
    unsigned entity_field_support() const override;

    int int_byte_size_db() const override { return int_byte_size_api(); }

  private:
    int64_t node_global_to_local__(int64_t /* global */, bool /* must_exist */) const override
    {
      return 0;
    }
    int64_t element_global_to_local__(int64_t /* global */) const override { return 0; }

    void read_meta_data__() override {}

    void flush_database__() const override;

    bool begin__(Ioss::State state) override;
    bool end__(Ioss::State state) override;

    bool begin_state__(int state, double time) override;
    bool end_state__(int state, double time) override;

    void initialize() const;

    NOOP_GFI(Ioss::Region)
    NOOP_GFI(Ioss::NodeBlock)
    NOOP_GFI(Ioss::EdgeBlock)
    NOOP_GFI(Ioss::FaceBlock)
    NOOP_GFI(Ioss::ElementBlock)
    NOOP_GFI(Ioss::StructuredBlock)
    NOOP_GFI(Ioss::SideBlock)
    NOOP_GFI(Ioss::NodeSet)
    NOOP_GFI(Ioss::EdgeSet)
    NOOP_GFI(Ioss::FaceSet)
    NOOP_GFI(Ioss::ElementSet)
    NOOP_GFI(Ioss::SideSet)
    NOOP_GFI(Ioss::CommSet)
    NOOP_GFI(Ioss::Assembly)
    NOOP_GFI(Ioss::Blob)

    int64_t put_field_internal(const Ioss::Region *region, const Ioss::Field &field, void *data,
                               size_t data_size) const override;

    NOOP_PFI(Ioss::NodeBlock)
    NOOP_PFI(Ioss::EdgeBlock)
    NOOP_PFI(Ioss::FaceBlock)
    NOOP_PFI(Ioss::ElementBlock)
    NOOP_PFI(Ioss::StructuredBlock)
    NOOP_PFI(Ioss::SideBlock)
    NOOP_PFI(Ioss::NodeSet)
    NOOP_PFI(Ioss::EdgeSet)
    NOOP_PFI(Ioss::FaceSet)
    NOOP_PFI(Ioss::ElementSet)
    NOOP_PFI(Ioss::SideSet)
    NOOP_PFI(Ioss::CommSet)
    NOOP_PFI(Ioss::Assembly)
    NOOP_PFI(Ioss::Blob)

    time_t timeLastFlush_{0};
    time_t flushInterval_{10};

    std::ostream           *logStream{nullptr};
    std::unique_ptr<Layout> layout_{};
    std::unique_ptr<Layout> legend_{};

    std::string defaultTsFormat{"[%H:%M:%S]"};
    std::string tsFormat{};
    std::string separator_{", "};
    int         precision_{5};
    int         fieldWidth_{0};
    bool        showLabels{true};
    bool        showLegend{false};
    bool        appendOutput{false};
    bool        addTimeField{false};

    bool   initialized_{false};
    bool   streamNeedsDelete{false};
    Format fileFormat{Format::DEFAULT};
  };
} // namespace Iohb
